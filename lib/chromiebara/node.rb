module Chromiebara
  class Node < Capybara::Driver::Node
    def initialize(driver, native, initial_cache)
      super driver, native, initial_cache
    end

    def all_text
      # TODO use promise dsl
      native.page.evaluate_function("e => e.textContent", native).await
    end

    def visible_text
      return '' unless visible?

      # TODO use promise dsl
      native.page.evaluate_function(ELEMENT_VISIBLE_TEXTS, native).await
    end

    def [](name)
      native.page.evaluate_function("(e, n) => e.getAttribute(n)", native, name).await
    end

    def find_css(selector)
      native.query_selector_all(selector).map do |element_handle|
        Node.new driver, element_handle, {}
      end
    end

    def find_xpath(selector)
      native.xpath(selector).map do |element_handle|
        Node.new driver, element_handle, {}
      end
    end

    def visible?
      native.is_intersecting_viewport
    end

    def style(styles)
      # TODO use promise dsl
      native.page.evaluate_function(GET_STYLES, native, styles).await
    end

    def click
      native.click
    end

    def checked?
      self[:checked]
    end

    def selected?
      !!self[:selected]
    end

    def disabled?
      native.page.evaluate_function(DISABLED, native).await
    end

    def focus
      native.focus
    end

    def hover
      native.hover
    end

    def ==(other)
      # TODO use promise dsl
      native.page.evaluate_function("(el, other) => el == other", native, other.native).await
    end

    private

      GET_STYLES = <<~JAVASCRIPT
      (element, styles) => {
        style = window.getComputedStyle(element);
        return styles.reduce((res,name) => {
          res[name] = style[name];
          return res;
        }, {})
      }
      JAVASCRIPT

      DISABLED = <<~JAVASCRIPT
      element => {
        const xpath = 'parent::optgroup[@disabled] | \
                       ancestor::select[@disabled] | \
                       parent::fieldset[@disabled] | \
                       ancestor::*[not(self::legend) or preceding-sibling::legend][parent::fieldset[@disabled]]';
        return element.disabled || document.evaluate(xpath, element, null, XPathResult.BOOLEAN_TYPE, null).booleanValue
      }
      JAVASCRIPT

      ELEMENT_VISIBLE_TEXTS = <<~JAVASCRIPT
      element => {
        if (element.nodeName == 'TEXTAREA'){
          return element.textContent;
        } else if (element instanceof SVGElement) {
          return element.textContent;
        } else {
          return element.innerText;
        }
      }
      JAVASCRIPT
  end
end
