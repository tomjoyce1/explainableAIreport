#import "@preview/lilaq:0.5.0" as lq
  
#set page(
  columns: 1,
 )

#show figure: it => {
  set text(size: 10pt)
  it
}

#figure(
  lq.diagram(
 
    width: 100%, 
    height: 60mm,  

    xaxis:(
      label:[Year],
      lim:(2014,2026)
    ),
    yaxis:(
      label:[nu pubs],
      lim:(0,3333)
    ),

    lq.plot(
      (2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025),
      (1, 1, 1, 1, 7, 9, 44, 54, 456, 1489, 1751),
      stroke:2pt + blue,
      mark:"dot",
    ),
  ),
  caption:[arXiv papers relating to AI hallucinations]  
)