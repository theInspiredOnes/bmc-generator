angular.module('bmc').service 'draggedElementServ', ->

	@draggedElement = null

	@getNewDragElement = -> '<div class="post-it"></div>'

	return