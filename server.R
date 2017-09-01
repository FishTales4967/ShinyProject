
# 
#

library(shiny)

shinyServer(  
  function(input, output) {   
        output$newPlot <-  renderPlot({
        P<- input$P
        I=input$I
        L=input$L
        amort<-T
        plotData<-F  
        J <- I/(12 * 100)
        N <- 12 * L
        M <- P*J/(1-(1+J)^(-N))
        monthPay <<- M
        #cat("\nThe payments for this loan are:\n 
        #    Monthly payment: $", M, " (stored in monthPay)\n
        #    Total cost: $", M*N, "\n\n", sep="")
        # Calculate Amortization for each Month
        if(amort==T) {
          Pt <- P # current principal or amount of the loan
          currP <- NULL
          while(Pt>=0) {
            H <- Pt * J # this is the current monthly interest
            C <- M - H # this is your monthly payment minus your monthly interest, so it is the amount of principal you pay for that month
            Q <- Pt - C # this is the new balance of your principal of your loan
            Pt <- Q # sets P equal to Q and goes back to step 1. The loop continues until the value Q (and hence P) goes to zero
            currP <- c(currP, Pt)
          }
          monthP <- c(P, currP[1:(length(currP)-1)])-currP
          aDFmonth <<- data.frame(
            Amortization=c(P, currP[1:(length(currP)-1)]), 
            Monthly_Payment=monthP+c((monthPay-monthP)[1:(length(monthP)-1)],0),
            Monthly_Principal=monthP, 
            Monthly_Interest=c((monthPay-monthP)[1:(length(monthP)-1)],0), 
            Year=sort(rep(1:ceiling(N/12), 12))[1:length(monthP)]
          )
          aDFyear <- data.frame(
            Amortization=tapply(aDFmonth$Amortization, aDFmonth$Year, max), 
            Annual_Payment=tapply(aDFmonth$Monthly_Payment, aDFmonth$Year, sum), 
            Annual_Principal=tapply(aDFmonth$Monthly_Principal, aDFmonth$Year, sum), 
            Annual_Interest=tapply(aDFmonth$Monthly_Interest, aDFmonth$Year, sum), 
            Year=as.vector(na.omit(unique(aDFmonth$Year)))
          )
          aDFyear <<- aDFyear
          MainTitle1 <- paste("Annual Interest and Principal Payments\n Total Repayment Cost = $",format(sum(aDFyear$Annual_Payment), big.mark=",", digits=2))
        MainTitle2 <-paste("\nAnnual Cost = $",format(aDFyear$Annual_Payment[1], big.mark=",", digits=2))
        MainTitle <- paste(MainTitle1,MainTitle2)
          #cat("The amortization data for each of the", N, "months are stored in \"aDFmonth\".\n\n")
         # cat("The amortization data for each of the", L, "years are stored in \"aDFyear\".\n\n")
        }
        
          barplot(t(aDFyear[,c(3,4)]), 
                  col=c("blue", "red"), 
                  main=MainTitle,
                  sub="\nMortgage function courtesy of Thomas Girke's 2007 source code on facult.UCR.edu ",
                  xlab="Years\n", ylab="$ Amount", 
                  legend.text=c("Principal", "Interest"), 
                  ylim=c(0, max(aDFyear$Annual_Payment)*1.3))
        })     
       }
)