(function ($) {
    $.app = {
        option: {
            api_url: '',
            photo_url_postfix: '',
            rows: 6,
            cols: 8,
            image_width: 0,
            image_height: 0,
            common_error: '本班级还没有照片哦，快去发布吧！'
        },
        data: {
            app: '',
            class_id: '',
            class_name: '',
            user_name: '',
            image_index: -1,
            images: []
        },
        animation: {
            timer: undefined,
            effects: [],
            interval: 3000,
            duration: 300,
            concur: 3,
            playing: false,
            next: -1
        },
        init: function () {
            // init data
            this.option.api_url =
                window.location.host.indexOf('test') !== -1 ? 'https://test.api.lebaoedu.com/album/photos?classId=' : 'https://app.lebaoedu.com/album/photos?classId=';

            this.data.app = this.getParameterByName('app');
            this.data.class_id = this.getParameterByName('classid');
            this.data.class_name = this.getParameterByName('classname');
            this.data.user_name = this.getParameterByName('username');
            document.title = this.data.class_name + '的回忆';

            // init view
            var border = $('.border'),
                container = $('.container'),
                image_container = $('.image_container');

            var top = $(document).width() * 0.45 + 'px';
            border.css('top', top);
            container.css('top', top);
            container.height(border.height());

            var tmp = Math.ceil(border.width() * 880 / 978 / 4);
            this.option.image_width = tmp * 4;
            this.option.image_height = tmp * 3;
            this.option.photo_url_postfix = '?imageView2/1/w/' + this.option.image_width + '/h/' + this.option.image_height;

            image_container.css({
                'top': Math.round((container.height() - this.option.image_height) / 2) + 'px',
                'left': Math.round((container.width() - this.option.image_width) / 2) + 'px',
                'width': this.option.image_width + 'px',
                'height': this.option.image_height + 'px',
                'background-color': 'transparent',
                'background-image': 'url("./images/default.jpg")',
                'background-position': '0px 0px',
                'background-repeat': 'no-repeat',
                'background-size': this.option.image_width + 'px ' + this.option.image_height + 'px'
            });

            $('.error_msg').text(this.option.common_error);
            if (this.data.app) {
                $('.share_button').click(function (event) {
                    event.stopPropagation();

                    if (/android/i.test($.app.data.app)) {
                        window.JSCall.shareClassAlbum();
                    } else if (/ios/i.test($.app.data.app)) {
                        location.href = 'lebaoedu://shareClassAlbum';
                    }
                });
            } else {
                $('.share_button').hide();
            }

            this.setupStages();
            this.loadEffects();
            this.queryData();

            // attach weixin share obj
            if (/micromessenger/i.test(navigator.userAgent)) {
                $.weixinshare.init(this.data.class_id, this.data.class_name, this.data.user_name);
            }
        },
        queryData: function () {
            if (this.option.api_url && this.data.class_id) {
                var that = this;
                $.ajax({
                    url: this.option.api_url + this.data.class_id,
                    type: "get",
                    async: false,
                    success: function (response) {
                        that.data.images = [];
                        if (response.code == 0 && response.data) {
                            $.each(response.data[0].albumPhotoes, function (index, photo) {
                                that.data.images.push(photo.photoUrl + that.option.photo_url_postfix);
                            });
                        }

                        if (that.data.images.length > 0) {
                            $('.play_button').show();
                            $('.border').click(function () {
                                $.app.toggleEffects();
                            });
                        }
                        else {
                            $('.error_msg').show();
                        }
                    },
                    error: function () {
                        $('.error_msg').show();
                    }
                })
            } else {
                $('.error_msg').show();
            }
        },
        getParameterByName: function (name) {
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(window.location.href);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        },
        setupStages: function () {
            var image_container = $('.image_container');
            var stage_div, stage_item;
            var width = Math.ceil(this.option.image_width / this.option.cols),
                height = Math.ceil(this.option.image_height / this.option.rows);

            // horizontal shutter
            stage_div = jQuery('<div/>', {'id': 'horizontal_shutter', 'class': 'stage'});
            for (var i = 0; i < this.option.cols; i++) {
                stage_item = jQuery('<div/>', {'class': 'stage_item'});
                stage_item.css({
                    'top': '0px',
                    'left': width * i + 'px',
                    'width': (Math.min(width, this.option.image_width - width * i) + 1) + 'px',
                    'height': '100%',
                    'background-color': 'transparent',
                    'background-position': '-' + width * i + 'px 0px',
                    'background-repeat': 'no-repeat',
                    'background-size': this.option.image_width + 'px ' + this.option.image_height + 'px'
                });
                stage_item.appendTo(stage_div);
            }
            stage_div.appendTo(image_container);

            // vertical shutter
            stage_div = jQuery('<div/>', {'id': 'vertical_shutter', 'class': 'stage'});
            for (var i = 0; i < this.option.rows; i++) {
                stage_item = jQuery('<div/>', {'class': 'stage_item'});
                stage_item.css({
                    'top': height * i + 'px',
                    'left': '0px',
                    'width': '100%',
                    'height': (Math.min(height, this.option.image_height - height * i) + 1) + 'px',
                    'background-color': 'transparent',
                    'background-position': '0px -' + height * i + 'px',
                    'background-repeat': 'no-repeat',
                    'background-size': this.option.image_width + 'px ' + this.option.image_height + 'px'
                });
                stage_item.appendTo(stage_div);
            }
            stage_div.appendTo(image_container);

            // grid shutter
            stage_div = jQuery('<div/>', {'id': 'grid_shutter', 'class': 'stage'});
            for (var i = 0; i < this.option.rows; i++) {
                for (var j = 0; j < this.option.cols; j++) {
                    stage_item = jQuery('<div/>', {'class': 'stage_item'});
                    stage_item.css({
                        'top': height * i + 'px',
                        'left': width * j + 'px',
                        'width': Math.min(width, this.option.image_width - width * j) + 'px',
                        'height': Math.min(height, this.option.image_height - height * i) + 'px',
                        'background-color': 'transparent',
                        'background-position': '-' + width * j + 'px -' + height * i + 'px',
                        'background-repeat': 'no-repeat',
                        'background-size': this.option.image_width + 'px ' + this.option.image_height + 'px'
                    });
                    stage_item.appendTo(stage_div);
                }
            }
            stage_div.appendTo(image_container);
        },
        loadEffects: function () {
        },
        toggleEffects: function () {
            var play_button = $('.play_button');

            if (this.animation.playing) {
                play_button.attr('src', './images/stop.png');
                play_button.show();

                this.animation.playing = false;
                this.pauseMusic();

                if (this.animation.timer) {
                    clearInterval(this.animation.timer);
                    this.animation.timer = undefined;
                }
            } else {
                play_button.hide();
                this.animation.playing = true;
                this.playMusic();
                this.nextEffect();
            }
        },
        nextEffect: function () {
            if (this.animation.effects.length > 0) {
                if (this.data.image_index >= 0)
                    $('.image_container').css('background-image', 'url("' + this.data.images[this.data.image_index] + '")');
                this.data.image_index = (this.data.image_index + 1) % this.data.images.length;

                $('.stage_item').hide();

                this.animation.next = (this.animation.next + Math.round(Math.random() * (this.animation.effects.length - 1)) + 1) % this.animation.effects.length;
                //this.animation.next = (this.animation.next + 1) % this.animation.effects.length;
                this.animation.effects[this.animation.next].play(this.data.images[this.data.image_index]);

                if (!this.animation.timer) {
                    this.animation.timer = setInterval(function () {
                        $.app.nextEffect();
                    }, this.animation.interval);
                }
            }
        },
        playMusic: function () {
            document.getElementById('music').play();
        },
        pauseMusic: function () {
            document.getElementById('music').pause();
        }
    };
})(jQuery);