(function ($) {
    $.app.animation.effects = [{
        name: 'h_fade_left',
        stage: 'horizontal_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * i).toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'h_fade_right',
        stage: 'horizontal_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (items.length - 1 - i)).toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'v_fade_top',
        stage: 'vertical_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * i).toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'v_fade_bottom',
        stage: 'vertical_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (items.length - 1 - i)).toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'mosaic_top_left',
        stage: 'grid_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (i % $.app.option.cols + Math.floor(i / $.app.option.cols)))
                        .toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'mosaic_top_right',
        stage: 'grid_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (($.app.option.cols - 1 - i % $.app.option.cols) + Math.floor(i / $.app.option.cols)))
                        .toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'mosaic_bottom_left',
        stage: 'grid_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (i % $.app.option.cols + ($.app.option.rows - 1 - Math.floor(i / $.app.option.cols))))
                        .toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'mosaic_bottom_right',
        stage: 'grid_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');
                for (var i = 0; i < items.length; i++) {
                    items.eq(i).delay(delay * (($.app.option.cols - 1 - i % $.app.option.cols) + ($.app.option.rows - 1 - Math.floor(i / $.app.option.cols))))
                        .toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'mosaic_random',
        stage: 'grid_shutter',
        play: function (image) {
            var delay = Math.round($.app.animation.duration / $.app.animation.concur / $.app.animation.concur);

            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                var arr = [], rand = 0, i = 0;
                for (i = 0; i < items.length; i++) {
                    arr.push(i);
                }

                for (i = 0; i < arr.length; i++) {
                    rand = Math.round(Math.random() * (arr.length - 1));
                    if (i !== rand) {
                        arr[i] += arr[rand];
                        arr[rand] = arr[i] - arr[rand];
                        arr[i] -= arr[rand];
                    }
                }

                for (i = 0; i < arr.length; i++) {
                    items.eq(arr[i]).delay(delay * i).toggle('fade', $.app.animation.duration);
                }
            }
        }
    }, {
        name: 'h_slide_left',
        stage: 'horizontal_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': 'left'}, $.app.animation.duration * 2);
                }
            }
        }
    }, {
        name: 'h_slide_right',
        stage: 'horizontal_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': 'right'}, $.app.animation.duration * 2);
                }
            }
        }
    }, {
        name: 'v_slide_down',
        stage: 'vertical_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': 'down'}, $.app.animation.duration * 2);
                }
            }
        }
    }, {
        name: 'v_slide_up',
        stage: 'vertical_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': 'up'}, $.app.animation.duration * 2);
                }
            }
        }
    }, {
        name: 'h_slide_cross',
        stage: 'horizontal_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': (i % 2 === 0) ? 'down' : 'up'}, $.app.animation.duration * 2);
                }
            }
        }
    }, {
        name: 'v_slide_cross',
        stage: 'vertical_shutter',
        play: function (image) {
            var items = $('#' + this.stage).children('.stage_item');
            if (items) {
                items.css('background-image', 'url("' + image + '")');

                for (var i = 0; i < items.length; i++) {
                    items.eq(i).toggle('slide', {'direction': (i % 2 === 0) ? 'left' : 'right'}, $.app.animation.duration * 2);
                }
            }
        }
    }];
})(jQuery);