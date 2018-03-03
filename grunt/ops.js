const cwd = process.cwd();
const spawn = require('child_process').spawn;

module.exports = (grunt) => {
  grunt.registerTask('ops', function() {
    const apply = !!grunt.option('apply');
    const done = this.async();
    const environment = grunt.config.get('environment');
    const settings = grunt.config.get('settings');
    const taint = grunt.option('taint') || null;
    const task = !!grunt.option('destroy') ? 'destroy' : (!!taint) ? 'taint' : 'apply';
    const terraform = require(`${cwd}/grunt/helpers/terraform.js`)(grunt, settings, environment);
    const args = [
      `--access=${settings.aws.credentials.access}`,
      `--secret=${settings.aws.credentials.secret}`,
      `--region=${settings.aws.region}`,
      `--bucket=${settings.aws.bucket}`,
      `--env=${environment}`
    ];

    if (!!taint) {
      args.push(`--module=${taint}`);
      args.push(`--resource=${grunt.option('resource')}`);
    }

    if (!!apply) {
      args.push('--apply');
    }

    const cmd = spawn(`./scripts/terraform/${task}.sh`, args, { cwd:`${cwd}`, shell: true, stdio: 'inherit' });

    cmd.on('close', (code) => {
      grunt.config.set('accessKeyID', settings.aws.credentials.access);
      grunt.config.set('secretAccessKey', settings.aws.credentials.secret);
      grunt.config.set('bucket', settings.aws.bucket);
      done();
    });

    cmd.on('error', (err) => {
      if (err) {
        grunt.fail.fatal(err);
      }
    });
  });
};
