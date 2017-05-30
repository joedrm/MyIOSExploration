({
    baseUrl: '../static',
    dir: '../static-built',
    modules: [
        {
            name: 'script/views/enterjs/mainconfig'
        }
    ],
    fileExclusionRegExp: /^(r|build)\.js$/,
    optimizeCss: 'standard',
    removeCombined: true,
    paths: {
        jquery:"script/libs/jquery",
        swiper:"script/plugs/swiper.min",
        diqu:"script/views/js/diqu2",
        commonObj:"script/views/js/commonobj" 
           }
})
