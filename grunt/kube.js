const cwd = process.cwd();
const helper = require(`${cwd}/grunt/helpers/kube.js`);

module.exports = (grunt) => {
  grunt.task.registerTask('kube', '', (subtask) => {
    helper[subtask](grunt);
  });
}
