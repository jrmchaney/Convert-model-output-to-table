#this function creates a APA formatted table from a GCA or mixed effects model output, including 95% Confidence Intervals.
#The output table is by no means perfect--you'll still need to go in and reformat a bit. 
#However, this function minimizes the hassle of copying coefficients and all the numbers by hand.

#written by Jacie R. McHaney on 11/13/2023

# model = the model variable name to export
# caption = the title for your table. Ex: caption <- 'Table 2. Fixed effect estimates for model of pupillary responses'
# outname = path and file name for the saved table with .docx extension

convert_table <- function(model,caption,outname){
  
  #install and load required packages
  pckgs <- c('insight','parameters','flextable','officer')
  
  using <- function(...){
    libs <- unlist(list(...))
    req <- unlist(lapply(libs,require,character.only = TRUE))
    need<-libs[req==FALSE]
    if(length(need)>0){
      install.packages(need)
      lapply(need,require,character.only=TRUE)
    }
  }
  
  using(pckgs)
  
  #download printy from github if not already installed
  inst <- is.element('printy',installed.packages()[,1])
  if(inst == FALSE){
    remotes::install_github('tjmahr/printy')
  }else{
    require(printy)
  }
  
  #get size of model
  num <- length(fixef(model))
  
  # load in model
  step1 <- parameters::model_parameters(model, conf.int = TRUE)
  
  #format for printing
  step2 <- step1 %>% 
    insight::format_table(pretty_names = FALSE) %>% 
    rename(t = 5) %>% 
    slice(1:num)
  
  # split into named lists
  
  final <- step2 %>% 
    printy::super_split(Effects,Parameter)
  
  #function for apa theme
  # set pad to 12 for double space
  theme_apa <- function(.data, pad = 12) {
    apa.border <- list("width" = 1, color = "black", style = "solid")
    font(.data, part = "all", fontname = "Times New Roman") %>%
      line_spacing(space = 1, part = "all") %>%
      padding(padding=pad) %>%
      hline_top(part = "head", border = apa.border) %>%
      hline_bottom(part = "head", border = apa.border) %>%
      hline_top(part = "body", border = apa.border) %>%
      hline_bottom(part = "body", border = apa.border) %>%
      align(align = "left", part = "all", j=-1) %>%
      valign(valign = "center", part = "body") %>%
      colformat_double(digits = 3) %>%
      fix_border_issues()
  }
  
  #make the table
  flextable1 <- step2 %>% 
    select(Parameter:p) %>% 
    flextable() %>% 
    autofit() %>% 
    set_caption(caption) %>% 
    #add_footer_lines(footnote, values = character(50), top = FALSE) %>%  #commenting this line out because of errors
    theme_apa()
  #print(flextable1) #preview the table
  
  #save the table
  doc <- officer::read_docx()
  doc <- flextable::body_add_flextable(doc,flextable1)
  print(doc, target = outname)

}