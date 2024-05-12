module Jekyll
module GetTitleFilter
def getTitle(item, par1, par2)
    par1 ? par1 : par2
end
end
end
Liquid::Template.register_filter(Jekyll::GetTitleFilter)
