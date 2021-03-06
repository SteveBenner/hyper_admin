angular.module("hyperadmin")
  .controller "IndexController", ($scope, $location, $state, Restangular, resourceClass, resourcePages) ->
    allPages = resourcePages

    @pagination =
      buttonsDisabled: false
      page: (parseInt($location.search().page) || 1)
      pages: ->
        return allPages if allPages.length <= 5

        current = @page

        first = if current >= 5
          allPages.slice (current - 5), (current - 1)
        else
          allPages.slice 0, (current - 1)

        last = allPages.slice (current), (current + 4)

        _.flatten [first, current, last]

    @resource_class = resourceClass

    $scope.$on "resource:created", (event, resource) =>
      @resources.push resource

    $scope.$on "resource:updated", (event, resource) =>
      @resources.forEach (res, index) =>
        if res.id == resource.id
          return @resources[index] = resource

    $scope.$on "resource:deleted", (event, resource) =>
      @loadPage()

    @loadPage = (callback) =>
      Restangular.all("admin/#{resourceClass.plural}")
        .getList(page: @pagination.page).then (resources) =>
          @resources = Restangular.stripRestangular resources

          callback() if callback?

    @gotoPrevPage = =>
      @pagination.buttonsDisabled = true

      @pagination.page--
      $location.search 'page', @pagination.page

      @loadPage => @pagination.buttonsDisabled = false

    @gotoNextPage = =>
      @pagination.buttonsDisabled = true

      @pagination.page++
      $location.search 'page', @pagination.page

      @loadPage => @pagination.buttonsDisabled = false

    @gotoPage = (page) =>
      @pagination.buttonsDisabled = true

      @pagination.page = page
      $location.search 'page', @pagination.page

      @loadPage => @pagination.buttonsDisabled = false

    @disablePrevPageButton = =>
      return true if @pagination.buttonsDisabled
      @pagination.page <= 1

    @disableNextPageButton = =>
      return true if @pagination.buttonsDisabled
      @pagination.page >= _.max(@pagination.pages())

    @disablePageButton = (number) =>
      return true if @pagination.buttonsDisabled
      number == @pagination.page

    @showLeftDots = =>
      @pagination.page > 5

    @showRightDots = =>
      @pagination.page < (_.max(allPages) - 4)

    @loadPage()

    this
