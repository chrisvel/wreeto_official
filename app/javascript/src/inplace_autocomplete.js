var ready = function(){
  function setupCodemirrorAutocomplete($cm) {
    var cm = $cm.get(0).CodeMirror;
  
    var isOpen = false;
    var query = '';
    var $popup = null;
    var results = [];
    var resultIdx = null;
    var keysPressed = [];
  
    // command key handler
    document.addEventListener('keydown',
      function (e) {
        if (!cm.hasFocus())
          return;
  
        if (isOpen) {
          if (e.key === 'Escape') {
            closePopup();
          } else if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
            e.preventDefault();
            selectOffset(e.key === 'ArrowDown' ? 1 : -1);
          } else if (e.key === 'Backspace') {
            if (e.ctrlKey) {
              e.preventDefault();
              return;
            }
  
            if (query){
              setQuery(query.substr(0, query.length - 2));
            }
            else
              closePopup();
          } else if (e.key === 'Enter' || e.key === 'Tab') {
            if (resultIdx !== null) {
              e.preventDefault();
              pick();
            }
          } else if (e.key === 'ArrowLeft' || e.key === 'ArrowRight') {
            // todo: for now?
            e.preventDefault();
          }
        } else {
          if (keysPressed['['] && e.key == '[')
            openPopup();
        }
      },
      true
    );

    document.addEventListener('keydown', (event) => {
      keysPressed[event.key] = true;
    });

    document.addEventListener('keyup', (event) => {
      if (keysPressed == [] && event.key != '['){
        delete keysPressed[event.key];
      }
    });
  
    // typing handler
    document.addEventListener('keypress',
      function (e) {
        if (!isOpen)
          return;
        if (query === '' && e.key == '[')
          return;
  
        setQuery(query + e.key);
      },
      true
    );
  
    // click outside to close
    document.addEventListener('click',
      function (e) {
        if (!isOpen)
          return;
  
        if (!$popup.get(0).contains(e.target))
          closePopup();
      }
    );
  
    /**
     * Displays the popup.
     */
    function openPopup() {
      if (isOpen)
        return;
  
      isOpen = true;
      var pos = $cm.find('.CodeMirror-cursor').offset();
      $popup = $('<div>').addClass('eac-popup').css({ top: pos.top + 30, left: pos.left });
      $popup.appendTo($('body'));
  
      refreshPopup();
    }
  
    /**
     * Hides the popup.
     */
    function closePopup() {
      if (!isOpen)
        return;
  
      $popup.remove();
      $popup = null;
  
      isOpen = false;
      query = '';
      results = [];
      resultIdx = null;
    }
  
    /**
     * Requests data from server with a debounce of 250ms.
     */
    var search = debounce(
      function () {
        $.ajax({
          url: '/notes/backlink_data',
          method: 'GET',
          data: {
            count: 7,
            query: query
          }
        }).then(data => {
          results = data;
          if (results && results.length)
            resultIdx = 0;
          refreshPopup();
        });
      },
      250
    );
  
    /**
     * Updates the query to a new value.
     * @param {string} q
     */
    function setQuery(q) {
      if (query === q)
        return;
  
      query = q;
      search(query);
    }
  
    /**
     * Renders the popup with updated data.
     */
    function refreshPopup() {
      if (!isOpen)
        return;
  
      $popup.empty();
  
      if (results.length > 0) {
        for (var i = 0; i < results.length; i++) {
          $popup.append(renderElem(i));
        }
      } else {
        $popup.append(renderEmptyMsg());
      }
  
      function renderElem(idx) {
        var isActive = idx === resultIdx;
        var text = results[idx].full_title;
  
        var $elem = $('<div>').addClass('eac-popup-item clickable')
          .text(text);
  
        if (isActive)
          $elem.addClass('active');
  
        $elem.on('mouseover', function () { $(this).addClass('active'); });
        $elem.on('mouseout', function () { if (!isActive) $(this).removeClass('active'); });
        $elem.on('click', function () { pick(idx); });
  
        return $elem;
      }
  
      function renderEmptyMsg() {
        return $('<div>').addClass('eac-popup-empty')
          .text(query ? 'No results have been found' : 'Enter your search term');
      }
    }
  
    /**
     * Selects the element by offset (1 for next, -1 for previous).
     * @param {number} offset
     */
    function selectOffset(offset) {
      selectIndex(resultIdx + offset);
    }
  
    /**
     * Selects the element as current, refreshing the popup.
     * @param {number} idx
     */
    function selectIndex(idx) {
      if (results.length === 0) {
        resultIdx = null;
        return;
      }
  
      resultIdx = idx;
  
      if (resultIdx >= results.length) {
        resultIdx = result.length - 1;
        return;
      }
  
      if (resultIdx < 0) {
        resultIdx = 0;
        return;
      }
  
      refreshPopup();
    }
  
    /**
     * Inserts the selection.
     */
    function pick(idx = null) {
      var result = results[idx || resultIdx];
      var cursor = cm.doc.getCursor();
      var markdown_link = '[[[' + result.title + '](http://localhost:8383/notes/' + result.guid + ')]]';

      //[title](https://wreeto.com/notes/<slug>)
      cm.replaceRange(
        // '[[' + result.title + '|' + result.title + ']]',
        // '[' + result.title + '](https://wreeto.com/notes/' + result.guid + ')',
        markdown_link,
        pos(cursor, query.length + 2),
        cursor
      );
  
      var cursor2 = cm.doc.getCursor();
      // cm.setSelection(
      //   pos(cursor2, markdown_link.length + 2),
      //   pos(cursor2, 2)
      // );
  
      closePopup();
  
      function pos(cursor, p) {
        return { line: cursor.line, ch: cursor.ch - p };
      }
    }
  };

  function debounce(func, wait) {
    let timeout;

    return function executedFunction() {
      var context = this;
      var args = arguments;

      var later = function () {
          timeout = null;
          func.apply(context, args);
      };

      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  };
  
  $(function () {
    $('.CodeMirror').each(function () {
      setupCodemirrorAutocomplete($(this));
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);