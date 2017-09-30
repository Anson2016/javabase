<!DOCTYPE html>
<html ng-app="iamge">
<head>
    <meta charset="UTF-8">
    <title>吧友图片</title>
    <meta name="keyworlds" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <meta http-equiv="Expires" content="-1">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="layoutmode" content="standard">
</head>
<#assign path=request.contextPath />
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
<link href="https://cdn.bootcss.com/blueimp-gallery/2.21.3/css/blueimp-gallery.css" rel="stylesheet">
<script src="https://cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdn.bootcss.com/blueimp-gallery/2.21.3/js/blueimp-gallery.min.js"></script>
<script src="https://cdn.bootcss.com/blueimp-gallery/2.21.3/js/jquery.blueimp-gallery.min.js"></script>
<script src="https://cdn.bootcss.com/angular.js/1.5.0/angular.js"></script>
<script src="https://ggjcdn.oss-cn-shanghai.aliyuncs.com/ng-infinite-scroll.min.js"></script>
<style>
    .lightBoxGallery img {
        margin: 5px;
        width: 160px;
    }
</style>
<#assign base=request.contextPath />
<body>
<ol class="breadcrumb">
    <div class="btn-group" role="group" aria-label="...">
        <a type="button" href="${path}/tieba/img/李毅/1/2" class="btn btn-default">李毅</a>
        <a type="button" href="${path}/tieba/img/wow/1/2" class="btn btn-default">wow</a>
        <a type="button" href="${path}/tieba/img/图解电影/1/2" class="btn btn-default">图解电影</a>
        <a type="button" href="${path}/tieba/img/腹肌/1/2" class="btn btn-default">腹肌</a>
        <a type="button" href="${path}/tieba/img/健身/1/2" class="btn btn-default">健身</a>
        <a type="button" href="${path}/tieba/img/摄影/1/2" class="btn btn-default">摄影</a>
    </div>
</ol>
<!-- The Gallery as lightbox dialog, should be a child element of the document body -->
<div id="blueimp-gallery" class="blueimp-gallery">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>
<div class="container-fluid">
    <div id="links" class="lightBoxGallery">
        <div class="row" ng-controller='scrollController'>
            <div class="panel panel-info">
                <div class="panel-heading">帖子查询</div>
                <div class="panel-body">
                    <form action="${base}/tieba/search" class="form-inline">
                        <div class="form-group">
                            <label for="keyWord">关键字</label>
                            <input type="text" class="form-control" id="keyWord" name="keyWord" placeholder="请输入关键字查询">
                        </div>
                    </form>
                </div>
            </div>
        <#if mapData??&&mapData?size gt 0>
            <#list mapData?keys as key>
                <#list mapData[key] as image>
                    <div class="col-md-3 col-xs-6 col-sm-4">
                        <div class="thumbnail">
                            <a href="${image}" title="吧友图片" data-gallery>
                                <img src="${image}">
                            </a>
                            <div class="caption">
                                <p><a class="btn btn-link" role="button" href="${key}" title="点击跳转到对应帖子">传送门</a></p>
                            </div>
                        </div>
                    </div>
                </#list>
            </#list>
        </#if>

            <div infinite-scroll='reddit.nextPage()' infinite-scroll-disabled='reddit.busy'
                 infinite-scroll-distance='0'>
                <div ng-repeat='object in reddit.links track by $index'>
                    <div ng-repeat='image in object.images'>
                        <div class="col-md-3 col-xs-6 col-sm-4">
                            <div class="thumbnail">
                                <a href="{{image}}" title="吧友图片" data-gallery>
                                    <img ng-src="{{image}}">
                                </a>
                                <div class="caption">
                                    <p><a class="btn btn-link" role="button" href="{{object.link}}" title="点击跳转到对应帖子">传送门</a>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style='clear: both;'></div>
                </div>
                <div ng-show='reddit.busy'>Loading data...</div>
            </div>
        </div>
    </div>
    <script>
        var iamge = angular.module('iamge', ['infinite-scroll']);

        iamge.controller('scrollController', function ($scope, Reddit) {
            $scope.reddit = new Reddit();
        });

        // Reddit constructor function to encapsulate HTTP and pagination logic
        iamge.factory('Reddit', function ($http) {
            var Reddit = function () {
                this.links = [];
                this.busy = false;
                this.after = 3;
            };

            Reddit.prototype.nextPage = function () {
                if (this.busy) return;
                this.busy = true;
                var that = this;
                var end = this.after + 3;
                var begin = this.after + 1;
                var tieBaName = "${tieBaName}";
                var url = "${path}/page/"+tieBaName+"/" + begin + "/" + end;
                $http.get(url).success(function (data) {
                    $.each(data, function (key, obj) {
                        var object = new Object();
                        object.link = key;
                        object.images = obj;
                        that.links.push(object);
                    });
                    this.after = this.after + 3;
                    this.busy = false;
                }.bind(this));
            };
            return Reddit;
        });
    </script>
</body>
<script src="https://ggjcdn.oss-cn-shanghai.aliyuncs.com/statistics.js"></script>
</html>
