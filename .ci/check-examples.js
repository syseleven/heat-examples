const fs = require('fs');
const glob = require('glob');
const leprechaun = require('leprechaun');
const path = require('path');

const subDirectories = glob.sync(__dirname + '/../*/', {
    ignore: [
        path.resolve(__dirname + '/../.ci'),
        path.resolve(__dirname + '/../node_modules/'),
        path.resolve(__dirname + '/../sources'),
    ]
});

let hasGlobalErrors = false;

subDirectories.forEach((directory) => {
    let hasErrors = false;
    const exampleName = directory.split('/').slice(-2, -1)[0];

    if (!exampleName.match(/^[a-z\-]+$/)) {
        leprechaun.error(`Example folder ${exampleName} should only contain lowercase characters and dashes`);
        hasErrors = true;
        hasGlobalErrors = true;
    }
    if (!fs.existsSync(path.join(directory, 'README.md'))) {
        leprechaun.error(`Example ${exampleName} does not contain a README.md file`);
        hasErrors = true;
        hasGlobalErrors = true;
    }
    if (!fs.existsSync(path.join(directory, '.*\.\yaml'))) {
        leprechaun.error(`Example ${exampleName} does not contain any .yaml file`);
        hasErrors = true;
        hasGlobalErrors = true;
    }

    if (!hasErrors) {
        leprechaun.success(`Example ${exampleName} is valid`)
    }
});

if (hasGlobalErrors) {
    process.exit(1);
}

