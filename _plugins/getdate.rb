module Jekyll
module GetDateFilter
def getDate(item, par1, par2)
    par1 ? par1 : par2.gsub(':', '-')
end
end
end
Liquid::Template.register_filter(Jekyll::GetDateFilter)
