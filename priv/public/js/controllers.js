var app = angular.module('slideShow', ['ui.bootstrap']);

app.factory('slideShowHomePageService', function ($http) {
	return {
		getChannelPictures: function (category, count, skip) {
			return $http.get('/api/slideshows/channel?c=' + category + '&l=' + count + '&skip=' + skip).then(function (result) {
				return result.data.articles;
			});
		}
	};
});
app.controller('SlideShowHome', function ($scope, slideShowHomePageService) {
	$scope.currentYear = (new Date).getFullYear();
	//the clean and simple way
	$scope.topNbaPictures = slideShowHomePageService.getChannelPictures('us_nba',2,0);
	$scope.topNflPictures = slideShowHomePageService.getChannelPictures('us_nfl',2,0);
	$scope.topNhlPictures = slideShowHomePageService.getChannelPictures('us_nhl',2,0);
	
	$scope.moreNbaPictures = slideShowHomePageService.getChannelPictures('us_nba',5,2);
	$scope.moreNflPictures = slideShowHomePageService.getChannelPictures('us_nfl',5,2);
	$scope.moreNhlPictures = slideShowHomePageService.getChannelPictures('us_nhl',5,2);
	
	var updateClock = function() {
	    $scope.clock = new Date();
	  };
	  var timer = setInterval(function() {
	    $scope.$apply(updateClock);
	  }, 1000);	  
	  updateClock();
	
});




