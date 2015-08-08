module LayoutHelper
  # Content to minimize <script> tags in html
  def javascript_jquery_ready(script)
    content_for(:javascript_jquery_ready) {
      script .gsub(/(<script>|<\/script>)/, "")
    }
  end
end