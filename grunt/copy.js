module.exports = {
  vault: {
    files: [
      {
        expand: true,
        src: ['secrets/**/*', '!secrets/vault-pass.txt'],
        dest: 'vault/'
      }
    ]
  }
}
