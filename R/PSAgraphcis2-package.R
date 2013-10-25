#' This packages provides functions to estimate and visualize multilvel propensity
#' score analysis.
#' 
#' This package extends the principles put forth by the \code{PSAgraphics} 
#' (Helmreich, Pruzek, & Xiong, 2010).
#'
#' @name PSAgraphics2-package
#' @aliases PSAgraphics2
#' @docType package
#' @title An R Package for Propensity Score Analysis
#' @author Jason Bryer \email{jason@@bryer.org}
#' @references \url{http://cran.r-project.org/web/packages/PSAgraphics/PSAgraphics.pdf}
#' 		\url{http://www.jstatsoft.org/v29/i06/}
#' @keywords propensity score analysis psa graphics
#' @seealso \code{PSAgraphics}
NA

#' Data on 996 initial Percutaneous Coronary Interventions (PCIs) performed in 
#' 1997 at the Lindner Center, Christ Hospital, Cincinnati.
#' 
#' Data from an observational study of 996 patients receiving a PCI at Ohio Heart 
#' Health in 1997 and followed for at least 6 months by the staff of the Lindner 
#' Center. This is a landmark dataset in the literature on propensity score 
#' adjustment for treatment selection bias due to practice of evidence based 
#' medicine; patients receiving abciximab tended to be more severely diseased 
#' than those who did not receive a IIb/IIIa cascade blocker.
#' 
#' @name lindner
#' @docType data
#' @format A data frame with 996 observations on the following 10 variables, no NAs.
#' \describe{
#' \item{\code{lifepres}}{Mean life years preserved due to survival for at least 
#' 6 months following PCI; numeric value of either 11.4 or 0.}
#' \item{\code{cardbill}}{Cardiac related costs incurred within 6 months of 
#' patient's initial PCI; numeric value in 1998 dollars; costs were truncated 
#' by death for the 26 patients with lifepres == 0.}
#' \item{\code{abcix}}{Numeric treatment selection indicator; 0 implies usual 
#' PCI care alone; 1 implies usual PCI care deliberately augmented by either 
#' planned or rescue treatment with abciximab.}
#' \item{\code{stent}}{Coronary stent deployment; numeric, with 1 meaning YES 
#' and 0 meaning NO.}
#' \item{\code{height}}{Height in centimeters; numeric integer from 108 to 196.}
#' \item{\code{female}}{Female gender; numeric, with 1 meaning YES and 0 meaning NO.}
#' \item{\code{diabetic}}{Diabetes mellitus diagnosis; numeric, with 1 meaning 
#' YES and 0 meaning NO.}
#' \item{\code{acutemi}}{Acute myocardial infarction within the previous 7 days; 
#' numeric, with 1 meaning YES and 0 meaning NO.}
#' \item{\code{ejecfrac}}{Left ejection fraction; numeric value from 0 percent 
#' to 90 percent.}
#' \item{\code{ves1proc}}{Number of vessels involved in the patient's initial 
#' PCI procedure; numeric integer from 0 to 5.}
#' }
#' @source Package USPS, by R. L. Obenchain.
#' @keywords datasets
NA

#' Programme of International Student Assessment (PISA) results from the United
#' States in 2009.
#' 
#' Student results from the 2009 Programme of International Student Assessment (PISA)
#' as provided by the Organization for Economic Co-operation and Development (OECD).
#' See \url{http://www.pisa.oecd.org/} for more information including the code book.
#'
#' Note that missing values have been imputed using the 
#' \href{mice}{http://cran.r-project.org/web/packages/mice/index.html} package.
#' Details on the specific procedure are in the \code{pisa.impute} function
#' in the \href{http://github.com/jbryer/pisa}{\code{pisa} package}.
#' 
#' @name pisausa
#' @docType data
#' @references Organisation for Economic Co-operation and Development (2009).
#'             Programme for International Student Assessment (PISA). 
#'             \url{http://www.pisa.oecd.org/}
#' @format a data frame with 5,233 rows and 70 columns.
#' \describe{
#' \item{\code{CNT}}{Country}
#' \item{\code{SCHOOLID}}{SchoolID}
#' \item{\code{ST01Q01}}{Grade}
#' \item{\code{ST04Q01}}{Sex}
#' \item{\code{ST05Q01}}{Attend}
#' \item{\code{ST06Q01}}{Age}
#' \item{\code{ST07Q01}}{Repeat}
#' \item{\code{ST08Q01}}{At home mother}
#' \item{\code{ST08Q02}}{At home father}
#' \item{\code{ST08Q03}}{At home brothers}
#' \item{\code{ST08Q04}}{At home sisters}
#' \item{\code{ST08Q05}}{At home grandparents}
#' \item{\code{ST08Q06}}{At home others}
#' \item{\code{ST10Q01}}{Mother highest schooling}
#' \item{\code{ST12Q01}}{Mother current job status}
#' \item{\code{ST14Q01}}{Father highest schooling}
#' \item{\code{ST16Q01}}{Father current job status}
#' \item{\code{ST19Q01}}{Language at home}
#' \item{\code{ST20Q01}}{Desk}
#' \item{\code{ST20Q02}}{Own room}
#' \item{\code{ST20Q03}}{Study place}
#' \item{\code{ST20Q04}}{Computer}
#' \item{\code{ST20Q05}}{Software}
#' \item{\code{ST20Q06}}{Internet}
#' \item{\code{ST20Q07}}{Literature}
#' \item{\code{ST20Q08}}{Poetry}
#' \item{\code{ST20Q09}}{Art}
#' \item{\code{ST20Q10}}{Textbooks}
#' \item{\code{ST20Q12}}{Dictionary}
#' \item{\code{ST20Q13}}{Dishwasher}
#' \item{\code{ST20Q14}}{DVD}
#' \item{\code{ST21Q01}}{How many cellphones}
#' \item{\code{ST21Q02}}{How many TVs}
#' \item{\code{ST21Q03}}{How many computers}
#' \item{\code{ST21Q04}}{How many cars}
#' \item{\code{ST21Q05}}{How many rooms bath or shower}
#' \item{\code{ST22Q01}}{How many books}
#' \item{\code{ST23Q01}}{Reading enjoyment time}
#' \item{\code{ST31Q01}}{Enrich in test language}
#' \item{\code{ST31Q02}}{Enrich in mathematics}
#' \item{\code{ST31Q03}}{Enrich in science}
#' \item{\code{ST31Q05}}{Remedial in test language}
#' \item{\code{ST31Q06}}{Remedial in mathematics}
#' \item{\code{ST31Q07}}{Remedial in science}
#' \item{\code{ST32Q01}}{Out of school lessons in test language}
#' \item{\code{ST32Q02}}{Out of school lessons maths}
#' \item{\code{ST32Q03}}{Out of school lessons in science}
#' \item{\code{PUBPRIV}}{Public or private school}
#' \item{\code{STRATIO}}{Student to teacher ratio in school}
#' }
NA

#' Character vector representing the list of covariates used for estimating
#' propensity scores.
#' 
#' @name pisa.psa.cols
#' @docType data
#' @format a character vector with covariate names for estimating propensity scores.
#' @keywords datasets
NULL
