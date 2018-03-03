const cwd = process.cwd();

module.exports = class Helper {
  static args(grunt) {
    const required = ['cluster', 'dns'];
    const settings = grunt.config.get('settings').aws;

    required.forEach((arg) => {
      if (!settings.kube.hasOwnProperty(arg)) {
        grunt.fail.fatal(`Grunt: required argument ${arg} missing`);
      }
    });
  }
  static available(grunt) {
    const zone = grunt.config.get('zone');
    const az =`${grunt.config.get('region')}${zone}`;

    if (grunt.config.get('zones').indexOf(az) <= -1) {
      grunt.fail.fatal(`Grunt: ${grunt.config.get('region')}${zone} not currently available`);
    } else {
      grunt.log.oklns(`Grunt: ${az} available`);
    }
  }
  static preflight(grunt) {
    Helper.args(grunt);
    Helper.region(grunt);
    Helper.zone(grunt);

    grunt.log.oklns('Grunt: Godspeed');
  }
  static region(grunt) {
    const region = grunt.option('region');

    if (!region) {
      grunt.fail.fatal('Grunt: Region required');
    } else if (!/^(us[-])+([a-z]{4}[-])+([\d]{1})$/.test(region)) {
      grunt.fail.fatal('Grunt: invalid region (e.g. us-west-1)');
    }

    grunt.config.set('region', region);
  }
  static zone(grunt) {
    const zone = grunt.option('zone');

    if (!zone) {
      grunt.fail.fatal('Grunt: zone required');
    } else if (!/^[a-c]{1}$/.test(zone)) {
      grunt.fail.fatal('Grunt: invalid zone (e.g. a, b or c)');
    }

    grunt.config.set('zone', zone);
  }
}
