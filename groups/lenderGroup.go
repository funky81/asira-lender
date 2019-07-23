package groups

import (
	"asira_lender/handlers"
	"asira_lender/middlewares"

	"github.com/labstack/echo"
)

func LenderGroup(e *echo.Echo) {
	g := e.Group("/lender")
	middlewares.SetClientJWTmiddlewares(g, "lender")

	// Profile endpoints
	g.GET("/profile", handlers.LenderProfile)
	g.PATCH("/profile", handlers.LenderProfileEdit)

	// Loans endpoints
	g.GET("/loanrequest_list", handlers.LenderLoanRequestList)
	g.GET("/loanrequest_list/:loan_id/detail", handlers.LenderLoanRequestListDetail)

	// Borrowers endpoints
	g.GET("/borrower_list", handlers.LenderBorrowerList)
}
