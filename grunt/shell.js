const cwd = process.cwd();
const execSync = require('child_process').execSync;
const grunt = require('grunt');

module.exports = {
  'kube-cleanup': {
    command: () => {
      return `sh ${cwd}/scripts/kube/cleanup.sh --env="${grunt.config.get('environment')}" --region="${grunt.config.get('region')}"`;
    }
  },
  'kube-init': {
    command: () => {
      const settings = grunt.config.get('settings').aws;
      const tf = grunt.file.readJSON(`${cwd}/tf/output/${grunt.config.get('region')}/${grunt.config.get('environment')}.json`);

      return `kube-aws init --cluster-name=${settings.kube.cluster} --external-dns-name=${settings.kube.dns} --region=${grunt.config.get('region')} --availability-zone=${grunt.config.get('region')}${grunt.config.get('zone')} --key-name=${tf['key-name'].value} --kms-key-arn="${tf['kms-arn'].value}"`;
    }
  },
  'kube-install': {
    command: () => {
      return `sh ${cwd}/scripts/kube/install.sh --uri="${grunt.config.get('download')}"`;
    }
  },
  'kube-latest': {
    options: {
      stdout: false,
      callback: (err, stdout, stderr, callback) => {
        if (err) {
          callback(err);
        }

        const releases = JSON.parse(stdout);
        for(i = releases.length - 1; i >= 0; i--) {
          const release = releases[i];

          if (!!release.prerelease) {
            continue;
          }

          grunt.config.set('download', `https://github.com/kubernetes-incubator/kube-aws/releases/download/${release.tag_name}/kube-aws-darwin-amd64.tar.gz`);
        }

        callback();
      }
    },
    command: () => {
      return `curl -s https://api.github.com/repos/kubernetes-incubator/kube-aws/releases`;
    }
  },
  requirements: {
    command: () => {
      return `sh ${cwd}/scripts/requirements.sh`;
    }
  },
  region: {
    options: {
      callback: (err, stdout, stderr, callback) => {
        if (err) {
          callback(err);
        }

        let available = false;
        const zones = [];

        JSON.parse(stdout).AvailabilityZones.forEach((az) => {
          if (az.State !== 'available') {
            return;
          }

          zones.push(az.ZoneName);
        });

        if (!!zones.length) {
          grunt.config.set('zones', zones);
          callback();
        } else {
          grunt.fail.fatal('Grunt: AZ not available');
        }
      }
    },
    command: () => {
      return `aws ec2 describe-availability-zones --region ${grunt.config.get('region')} --profile recess`
    }
  }
};
