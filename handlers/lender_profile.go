package handlers

import (
	"asira_lender/models"
	"net/http"
	"strconv"

	"github.com/thedevsaddam/govalidator"

	jwt "github.com/dgrijalva/jwt-go"
	"github.com/labstack/echo"
)

func LenderProfile(c echo.Context) error {
	defer c.Request().Body.Close()

	user := c.Get("user")
	token := user.(*jwt.Token)
	claims := token.Claims.(jwt.MapClaims)

	lenderModel := models.Bank{}

	lenderID, _ := strconv.Atoi(claims["jti"].(string))
	lender, err := lenderModel.FindbyID(lenderID)
	if err != nil {
		return returnInvalidResponse(http.StatusForbidden, err, "unauthorized")
	}

	return c.JSON(http.StatusOK, lender)
}

func LenderProfileEdit(c echo.Context) error {
	defer c.Request().Body.Close()

	user := c.Get("user")
	token := user.(*jwt.Token)
	claims := token.Claims.(jwt.MapClaims)

	lenderModel := models.Bank{}

	lenderID, _ := strconv.Atoi(claims["jti"].(string))
	lender, err := lenderModel.FindbyID(lenderID)
	if err != nil {
		return returnInvalidResponse(http.StatusForbidden, err, "unauthorized")
	}

	payloadRules := govalidator.MapData{
		"id":       []string{"unrequired"},
		"name":     []string{},
		"type":     []string{},
		"address":  []string{},
		"province": []string{},
		"city":     []string{},
		"services": []string{},
		"pic":      []string{},
		"phone":    []string{"id_phonenumber"},
	}

	validate := validateRequestPayload(c, payloadRules, &lender)
	if validate != nil {
		return returnInvalidResponse(http.StatusUnprocessableEntity, validate, "validation error")
	}

	_, err = lender.Save()
	if err != nil {
		return returnInvalidResponse(http.StatusUnprocessableEntity, err, "error saving profile")
	}

	return c.JSON(http.StatusOK, lender)
}
