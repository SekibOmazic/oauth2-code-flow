import './main.css'
import { getToken, setToken } from './js/token'

const logoPath = 'logo.svg'

const Elm = require('./src/Main.elm')

const app = Elm.Main.embed(document.getElementById('root'), logoPath)

// check if there is a token in the local storage
app.ports.check.subscribe(() => {
  const token = getToken()
  console.log("LOADING Token from the localStorage", token)

  app.ports.tokenChecked.send(token)
})

app.ports.saveToken.subscribe( (token) => {
  setToken(token)
})
