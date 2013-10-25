angular.module('bmc', []);
angular.module('bmc').directive('area', function () {
  return {
    restrict: 'C',
    scope: true,
    template: '<div class="area__head">\n\t<input class="area__title" type="text" value="{{title}}"></input>\n\t<button class="area__add-element" title="Add new element"></button>\n</div>\n<div class="area__dropzone"></div>',
    link: function (scope, element, attrs) {
      var addElement, dragLeave, dragOver, drop;
      scope.title = attrs.caption;
      drop = function (event) {
        if (event.stopPropagation) {
          event.stopPropagation();
        }
        return scope.$broadcast('area::appendDraggedElement');
      };
      dragOver = function (event) {
        if (event.preventDefault) {
          event.preventDefault();
        }
        event.dataTransfer.dropEffect = 'move';
        return element.addClass('area--dragover');
      };
      dragLeave = function () {
        return element.removeClass('area--dragover');
      };
      addElement = function () {
        return scope.$broadcast('area::appendNewElement');
      };
      scope.$on('areaDropzone::elementDropped', dragLeave);
      scope.$on('postIt::elementDropped', dragLeave);
      scope.$on('areaAddElement::addNewElement', addElement);
      element.bind('drop', drop);
      element.bind('dragover', dragOver);
      element.bind('dragleave', dragLeave);
    }
  };
});
angular.module('bmc').directive('areaAddElement', function () {
  return {
    restrict: 'C',
    template: '+',
    link: function (scope, element) {
      var addElement;
      addElement = function () {
        return scope.$emit('areaAddElement::addNewElement');
      };
      element.bind('click', addElement);
    }
  };
});
angular.module('bmc').directive('areaDropzone', [
  'draggedElementServ',
  '$compile',
  function (draggedElementServ, $compile) {
    return {
      restrict: 'C',
      scope: true,
      link: function (scope, element, attrs) {
        var addElement, dropElement;
        dropElement = function () {
          element.append(draggedElementServ.draggedElement);
          return scope.$emit('areaDropzone::elementDropped');
        };
        addElement = function () {
          var newElement;
          newElement = $compile(draggedElementServ.getNewDragElement())(scope);
          return element.append(newElement);
        };
        scope.$on('area::appendDraggedElement', dropElement);
        scope.$on('area::appendNewElement', addElement);
      }
    };
  }
]);
angular.module('bmc').directive('postIt', [
  'draggedElementServ',
  function (draggedElementServ) {
    return {
      restrict: 'C',
      scope: true,
      template: '<button class="post-it__delete" title="Delete"></button>\n<textarea ng-model="data.text"></textarea>',
      link: function (scope, element, attrs) {
        var dragEnd, dragStart, drop;
        element.attr('draggable', 'true');
        scope.data = {};
        dragStart = function (event) {
          draggedElementServ.draggedElement = element;
          element.addClass('post-it--dragged');
          return event.dataTransfer.setData('Text', '');
        };
        dragEnd = function () {
          return element.removeClass('post-it--dragged');
        };
        drop = function (event) {
          if (event.stopPropagation) {
            event.stopPropagation();
          }
          scope.$emit('postIt::elementDropped');
          return element.after(draggedElementServ.draggedElement);
        };
        element.bind('dragstart', dragStart);
        element.bind('dragend', dragEnd);
        element.bind('drop', drop);
      },
      controller: [
        '$scope',
        '$element',
        function ($scope, $element) {
          var deleteMe;
          deleteMe = function () {
            return $element.remove();
          };
          $scope.$on('postItDelete::delete', deleteMe);
        }
      ]
    };
  }
]);
angular.module('bmc').directive('postItDelete', function () {
  return {
    restrict: 'C',
    template: '&times;',
    link: function (scope, element, attrs) {
      var deletePostIt;
      deletePostIt = function () {
        return scope.$emit('postItDelete::delete');
      };
      element.bind('click', deletePostIt);
    }
  };
});
angular.module('bmc').service('draggedElementServ', function () {
  this.draggedElement = null;
  this.getNewDragElement = function () {
    return '<div class="post-it"></div>';
  };
});