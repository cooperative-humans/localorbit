(function() {
  $(function() {
    var clipText, fitText, resizeContent, resizePosterFarmName, resizePosterHeader, resizeTTContent, resizeTTFarmName, resizeTTHeader;
    fitText = function(element, maxHeight, clipHeight, minFont) {
      var fontSize, height, newHeight, ref, ref1, ref2, ref3, results;
      height = (ref = $(element)) != null ? (ref1 = ref[0]) != null ? ref1.scrollHeight : void 0 : void 0;
      results = [];
      while (height > maxHeight) {
        fontSize = $(element).css("font-size").replace(/px/, "");
        $(element).css("font-size", (fontSize * 0.95) + "px");
        newHeight = (ref2 = $(element)) != null ? (ref3 = ref2[0]) != null ? ref3.scrollHeight : void 0 : void 0;
        if (newHeight === height || fontSize <= minFont) {
          clipText(element, clipHeight);
          results.push(height = -1);
        } else {
          results.push(height = newHeight);
        }
      }
      return results;
    };
    clipText = function(element, maxHeight) {
      var attempts, height, newWords, results, wordCount, words;
      height = $(element)[0].scrollHeight;
      attempts = 0;
      words = $(element).text().split(' ');
      wordCount = words.length;
      results = [];
      while (height > maxHeight && attempts < wordCount) {
        attempts += 1;
        newWords = words.slice(0, +(wordCount - (1 + attempts)) + 1 || 9e9);
        $(element).text(newWords.join(' '));
        results.push(height = $(element)[0].scrollHeight);
      }
      return results;
    };
    resizeContent = function() {
      return $(".farm-content p").each(function() {
        var el;
        el = this;
        return fitText(el, 1900, 3900, 14);
      });
    };
    resizeTTContent = function() {
      return $(".tt-farm-content p").each(function() {
        var el;
        el = this;
        return fitText(el, 1900, 2500, 9);
      });
    };
    resizeTTHeader = function() {
      return $("h1.productName").each(function() {
        var el;
        el = this;
        return fitText(el, 60, 2100, 14);
      });
    };
    resizeTTFarmName = function() {
      return $(".tt-farm-name").each(function() {
        var el;
        el = this;
        return fitText(el, 86, 2086, 16);
      });
    };
    resizePosterHeader = function() {
      return $("h1.headerPosterText").each(function() {
        var el;
        el = this;
        return fitText(el, 235, 2235, 24);
      });
    };
    resizePosterFarmName = function() {
      return $(".farm-name").each(function() {
        var el;
        el = this;
        return fitText(el, 106, 2106, 24);
      });
    };
    resizeContent();
    resizeTTContent();
    resizeTTHeader();
    resizeTTFarmName();
    resizePosterHeader();
    return resizePosterFarmName();
  });

}).call(this);
