unless String.public_method_defined?(:to_html)
  String.send :alias_method, :to_html, :to_s
end
