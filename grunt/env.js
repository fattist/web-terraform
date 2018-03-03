module.exports = (grunt) => {
  grunt.registerTask('env', () => {
    const env = grunt.option('env');
    const environment = /^(stag)(e|ing)/.test(env) ? 'staging' : /^(prod)(uction)?/.test(env) ? 'production' : /^(dev)(evelopment)?/.test(env) ? 'development' : null;

    if (!environment) {
      grunt.fail.fatal('Grunt: Environment unknown');
    } else {
      grunt.config.set('environment', environment);
      grunt.log.writeln(`environment: ${environment}`);
    }

    console.log(grunt.config.get('environment'), 'env');
  });
}
