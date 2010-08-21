class String
  def translit
    Russian.translit(self)
  end

  def to_css
    translit.parameterize.gsub(/[[:punct:]]/, '_').underscore
  end
end

