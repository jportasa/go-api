package main

import (
	"fmt"
	"net/http"
	"log"
	"encoding/json"
	"github.com/gorilla/mux"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	"os"
)

type User struct {
	ID string `json:"id"`
	Name string `json:"name"`
}

func Handler(w http.ResponseWriter, r *http.Request) {
	// Connect to database
	host := os.Getenv("DBHOST")
	dsn := fmt.Sprintf("root@tcp(%s:3306)/users", host)
	db, err := sql.Open("mysql", dsn)
	if err != nil{
		fmt.Println("Error validating sql Open arguments", err)
		panic(err.Error())
	}
	defer db.Close()
	err = db.Ping()
	if err != nil {
		fmt.Println("Error verifiing connection with db.Ping", err)
		panic(err.Error)
	}
	switch r.Method {
        case "GET":	
			var users []User
			w.Header().Set("Content-Type", "application/json")
			// read from database
			result, err := db.Query("SELECT * from users")
			if err != nil {
				panic(err)
			}
			defer result.Close()
			for result.Next() {
				var user User
				err := result.Scan(&user.ID, &user.Name)
				if err != nil {
				  panic(err.Error())
				}
				users = append(users, user)
			  }
			  w.WriteHeader(http.StatusOK)
			  json.NewEncoder(w).Encode(users)
		case "POST":
			w.Header().Set("Content-Type", "application/json")
			var user User

			err := json.NewDecoder(r.Body).Decode(&user)
			if err != nil {
				panic(err.Error())
			}
			insert, err := db.Query("INSERT INTO users(`id`,`name`) VALUES(?,?)",user.ID, user.Name )
			if err != nil {
				panic(err.Error())
			}
			defer insert.Close()
    }
}

func main(){
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/users", Handler)
	router.HandleFunc("/user", Handler)
	log.Fatal(http.ListenAndServe(":3001", router))
}