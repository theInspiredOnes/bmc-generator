angular.module('bmc', []);
angular.module('bmc').service('draggedElementServ', function () {
  this.draggedElement = null;
  this.getNewDragElement = function () {
    return '<div class="post-it"></div>';
  };
});
angular.module('bmc').service('areaServ', function () {
  var count;
  count = 0;
  this.areaAdded = function () {
    return ++count;
  };
  this.areaRemoved = function () {
    return --count;
  };
  this.getAreaCount = function () {
    return count;
  };
});
angular.module('bmc').directive('postIt', [
  'draggedElementServ',
  function (draggedElementServ) {
    return {
      restrict: 'C',
      scope: true,
      template: '<button class="post-it__delete" title="Delete"></button>\n<textarea ng-model="data.text"></textarea>',
      link: function (scope, elm, attrs) {
        var dragEnd, dragStart, drop;
        elm.attr('draggable', 'true');
        scope.data = {};
        dragStart = function (event) {
          draggedElementServ.draggedElement = elm;
          elm.addClass('post-it--dragged');
          return event.dataTransfer.setData('Text', '');
        };
        dragEnd = function () {
          return elm.removeClass('post-it--dragged');
        };
        drop = function (event) {
          if (event.stopPropagation) {
            event.stopPropagation();
          }
          scope.$emit('area::elementDropped');
          return elm.after(draggedElementServ.draggedElement);
        };
        elm.bind('dragstart', dragStart);
        elm.bind('dragend', dragEnd);
        elm.bind('drop', drop);
      },
      controller: [
        '$scope',
        '$element',
        function ($scope, $element) {
          var deleteMe;
          deleteMe = function () {
            return $element.remove();
          };
          $scope.$on('postIt::delete', deleteMe);
        }
      ]
    };
  }
]);
angular.module('bmc').directive('postItDelete', function () {
  return {
    restrict: 'C',
    template: '&times;',
    link: function (scope, elm, attrs) {
      var deletePostIt;
      deletePostIt = function () {
        return scope.$emit('postIt::delete');
      };
      elm.bind('click', deletePostIt);
    }
  };
});
angular.module('bmc').directive('area', [
  'areaServ',
  function (areaServ) {
    return {
      restrict: 'C',
      scope: true,
      template: '<div class="area__head">\n\t<input class="area__title" type="text" value="{{title}}"></input>\n\t<button class="area__add-element" title="Add new element"></button>\n</div>\n<div class="area__dropzone"></div>',
      link: function (scope, elm) {
        var addElement, dragEnter, dragLeave, dragOver, drop;
        areaServ.areaAdded();
        drop = function (event) {
          if (event.stopPropagation) {
            event.stopPropagation();
          }
          return scope.$broadcast('area::appendDraggedElement');
        };
        dragEnter = function () {
          return elm.addClass('area--dragover');
        };
        dragOver = function (event) {
          if (event.preventDefault) {
            event.preventDefault();
          }
          return event.dataTransfer.dropEffect = 'move';
        };
        dragLeave = function () {
          return elm.removeClass('area--dragover');
        };
        addElement = function () {
          return scope.$broadcast('area::appendNewElement');
        };
        scope.$on('area::elementDropped', dragLeave);
        scope.$on('area::addNewElement', addElement);
        elm.bind('drop', drop);
        elm.bind('dragenter', dragEnter);
        elm.bind('dragover', dragOver);
        elm.bind('dragleave', dragLeave);
      }
    };
  }
]);
angular.module('bmc').directive('areaTitle', [
  'areaServ',
  function (areaServ) {
    return {
      restrict: 'C',
      scope: true,
      controller: [
        '$scope',
        '$element',
        function ($scope, $element) {
          $scope.title = 'Area ' + areaServ.getAreaCount();
        }
      ]
    };
  }
]);
angular.module('bmc').directive('areaAddElement', function () {
  return {
    restrict: 'C',
    template: '+',
    link: function (scope, elm) {
      var addElement;
      addElement = function () {
        return scope.$emit('area::addNewElement');
      };
      elm.bind('click', addElement);
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
      link: function (scope, elm, attrs) {
        var addElement, dropElement;
        dropElement = function () {
          elm.append(draggedElementServ.draggedElement);
          return scope.$emit('area::elementDropped');
        };
        addElement = function () {
          var newElement;
          newElement = $compile(draggedElementServ.getNewDragElement())(scope);
          return elm.append(newElement);
        };
        scope.$on('area::appendDraggedElement', dropElement);
        scope.$on('area::appendNewElement', addElement);
      }
    };
  }
]);