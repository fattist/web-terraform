const cwd = process.cwd();
const fs = require('fs');
const nunjucks = require('nunjucks');
const Helper = class terraform {
  constructor(grunt, config, env) {
    let vars = {};
    this.environment = env;
    this.config = config.aws;
    this.tpl = {};

    if (this.config.hasOwnProperty('dependencies')) {
      vars = this.multiAZvars(grunt);
    }

    this.createTemplates(vars);
    this.varFileHandler();
  }
  get backend() {
    return {
      BUCKET: this.config.bucket,
      KEY: `${this.config.region}/${this.environment}/terraform.tfstate`,
      PROFILE: this.config.profile || 'fattist',
      REGION: this.config.backend.region
    }
  }
  createTemplates(vars) {
    ['backend', 'variables'].forEach((file) => {
      const opts = !!this[file] ? this[file] : Object.assign({}, this.meow({ ENVIRONMENT: this.environment }), vars);
      const tpl = file === 'backend' ? 'backend' : 'env';

      if (!!this[file]) {
        this.tpl[file] = nunjucks.render(`${cwd}/grunt/templates/terraform/${tpl}.njk`, opts);
      } else {
        let whorefish = '';

        for (const prop in opts) {
          const ctx = {};
          ctx.key = prop;
          ctx.prop = opts[prop];

          whorefish += nunjucks.render(`${cwd}/grunt/templates/${tpl}.njk`, ctx);
        }

        this.tpl[file] = whorefish;
      }
    });
  }
  meow(obj) {
    const tmp = { AWS_ENVIRONMENT: this.environment };
    const meowmix = (ctx, parent = 'aws') => {
      for (const prop in ctx) {
        if (prop === 'dependencies') {
          continue;
        } else if (typeof ctx[prop] === 'string' || typeof ctx[prop] === 'number') {
          tmp[`${parent}_${prop}`.toUpperCase()] = ctx[prop];
        } else {
          meowmix(ctx[prop], prop);
        }
      }
    }

    meowmix(this.config);
    return tmp;
  }
  multiAZvars(grunt) {
    let output;
    const opts = {};

    try {
      output = grunt.file.readJSON(`${cwd}/tf/output/${this.config.dependencies.region}/${this.environment}.json`);
    } catch(error) {
      grunt.fail.fatal('Grunt: missing terraform environment configuration asdfasdfas');
    }

    this.config.dependencies.keys.forEach((key) => {
      if (!output.hasOwnProperty(key)) {
        grunt.fail.fatal(`Grunt: ${key} missing from ${this.config.dependencies.region}`);
      } else {
        opts[key.toUpperCase().replace(/[-]/g, '_')] = output[key].value;
      }
    });

    return opts;
  }
  settings(region) {
    const obj = {};

    for(const key in region) {
      if (region.hasOwnProperty(key)) {
        for(const prop in region[key]) {
          obj[`${key.toUpperCase()}_${prop.toUpperCase()}`] = region[key][prop];
        }
      }
    }

    return obj;
  }
  varFileHandler() {
    const varfiles = ['backend', 'variables'];

    varfiles.forEach((varfile) => {
      const path = `${cwd}/tf/.generated/${varfile}.tfvars`;
      const exists = fs.existsSync(path);

      if (!!exists) {
        fs.unlinkSync(path);
      }

      fs.writeFileSync(path, this.tpl[varfile]);
    });
  }
}

module.exports = (grunt, config, env) => {
  return new Helper(grunt, config, env);
}
