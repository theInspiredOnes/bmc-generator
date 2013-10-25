angular.module 'bmc', []

angular.module('bmc').service 'draggedElementServ', ->
	@draggedElement = null
	@getNewDragElement = -> '<div class="post-it"></div>'
	return

angular.module('bmc').service 'areaServ', ->
	count = 0
	@areaAdded = -> ++count
	@areaRemoved = -> --count
	@getAreaCount = -> count
	return

angular.module('bmc').directive 'postIt', (draggedElementServ) ->
	restrict: 'C'
	scope: true
	template:
		'''
			<button class="post-it__delete" title="Delete"></button>
			<textarea ng-model="data.text"></textarea>
		'''
	link: (scope, elm, attrs) ->
		elm.attr 'draggable', 'true'
		scope.data = {}

		dragStart = (event) ->
			draggedElementServ.draggedElement = elm
			elm.addClass 'post-it--dragged'
			#event.dataTransfer.setData('Text', scope.data.text);
			event.dataTransfer.setData('Text', '');

		dragEnd = -> elm.removeClass 'post-it--dragged'

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$emit 'area::elementDropped'
			elm.after draggedElementServ.draggedElement

		elm.bind 'dragstart', dragStart
		elm.bind 'dragend', dragEnd
		elm.bind 'drop', drop
		return

	controller: ($scope, $element) ->
		deleteMe = -> $element.remove()
		$scope.$on 'postIt::delete', deleteMe
		return

angular.module('bmc').directive 'postItDelete', ->
	restrict: 'C'
	template: '&times;'
	link: (scope, elm, attrs) ->
		deletePostIt = -> scope.$emit 'postIt::delete'
		elm.bind 'click', deletePostIt
		return

angular.module('bmc').directive 'area', (areaServ) ->
	restrict: 'C'
	scope: true
	template:
		'''
			<div class="area__head">
				<input class="area__title" type="text" value="{{title}}"></input>
				<button class="area__add-element" title="Add new element"></button>
			</div>
			<div class="area__dropzone"></div>
		'''
	link: (scope, elm) ->
		areaServ.areaAdded()

		drop = (event) ->
			if event.stopPropagation then event.stopPropagation()
			scope.$broadcast 'area::appendDraggedElement'

		dragEnter = ->	elm.addClass 'area--dragover'

		dragOver = (event) ->
			if event.preventDefault then event.preventDefault()
			event.dataTransfer.dropEffect = 'move'

		dragLeave = -> elm.removeClass 'area--dragover'
		addElement = -> scope.$broadcast 'area::appendNewElement'
		
		scope.$on 'area::elementDropped', dragLeave
		scope.$on 'area::addNewElement', addElement

		elm.bind 'drop', drop
		elm.bind 'dragenter', dragEnter
		elm.bind 'dragover', dragOver
		elm.bind 'dragleave', dragLeave
		return

angular.module('bmc').directive 'areaTitle', (areaServ) ->
	restrict: 'C'
	scope: true
	controller: ($scope, $element) ->
		$scope.title = "Area #{areaServ.getAreaCount()}"
		return

angular.module('bmc').directive 'areaAddElement', ->
	restrict: 'C'
	template: '+'
	link: (scope, elm) ->
		addElement = -> scope.$emit 'area::addNewElement'
		elm.bind 'click', addElement
		return

angular.module('bmc').directive 'areaDropzone', (draggedElementServ, $compile) ->
	restrict: 'C'
	scope: true
	link: (scope, elm, attrs) ->
		dropElement = ->
			elm.append draggedElementServ.draggedElement
			scope.$emit 'area::elementDropped'

		addElement = -> 
			newElement = $compile(draggedElementServ.getNewDragElement())(scope)
			elm.append newElement

		scope.$on 'area::appendDraggedElement', dropElement
		scope.$on 'area::appendNewElement', addElement
		return
