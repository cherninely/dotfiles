module.exports = {
    defaultBrowser: 'Google Chrome',
    handlers: [
        {
            match: ['*yandex-team*', '*nda*', '*localhost*'],
            browser: 'Yandex'
        },
        {
            match: '*',
            browser: 'Google Chrome'
        },
    ]
};
