module.exports = {
    defaultBrowser: 'Google Chrome',
    handlers: [
        {
            match: ['*yandex-team*', '*nda*'],
            browser: 'Yandex'
        },
        {
            match: '*',
            browser: 'Google Chrome'
        },
    ]
};
