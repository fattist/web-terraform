const cwd = process.cwd();

module.exports = (grunt) => {
  grunt.registerTask('config', () => {
    const region = grunt.option('region') || null;
    const zone = grunt.option('zone') || null;

    if (!region || !zone) {
      grunt.fail.fatal('Grunt: region and zone are required');
    }

    const file = !/(us)/.test(region) ? `us-${region}-${zone}` : `${region}`;
    grunt.config.set('settings', grunt.file.readYAML(`${cwd}/secrets/aws/${file}.yml`));
    console.log(grunt.config.get('settings'));
  });
}
