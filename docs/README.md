#Setup

Install mermaid:
`gem install jekyll-mermaid`

#Adding posts

Posts should be stored in _posts directory, with the title like
`year`-`month`-`day`-`title`.`format`

###Valid postnames

```
2011-12-31-new-years-eve-is-awesome.md
2012-09-12-how-to-write-a-blog.textile
```

###Valid sections
``` 
['gen', 'General'],
['cor', 'Core'],
['jav', 'Java'],
['obj', 'Objective-C'],
['mis', 'Misc']
```

###Post definition header
```bash
---
layout: default
category: doc
title: "General Documentation"
---
```

[More help](http://bruth.github.io/jekyll-docs-template/)
