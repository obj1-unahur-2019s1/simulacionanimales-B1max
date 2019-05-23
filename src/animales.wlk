import wollok.game.*

class Vaca {
	var property position = game.at(3,5)
	const property image = "vaca.gif"
	var peso = 500
	var tieneSed = false
	method tieneSed(){return tieneSed}
	method peso (){return peso}
	method comer(cant){
		peso += cant/2
		tieneSed = true
	}
	method tieneHambre(){return peso<200 }
	method beber(){
		tieneSed = false
		peso -= 1
	}
	method subir (){
		self.position(self.position().down(1))
		peso = (peso*0.95).max(50)
	}
}
class Gallina{
	var property position = game.at(4,5)
	const property image = "granGallina.jpg"
	var peso = 4
	var vecesCome = 0
	method tieneSed(){return vecesCome==2 or vecesCome==5}
	method peso(){return peso}
	method comer(cant){
		vecesCome += 1
	}
	method beber(){
	}

}
class Comedero{
	var pesoMax = 1
	var cantRaciones = 1000
	
	method puedeAtender(){
	//si tiene hambre, no supera el pesopeso bla+
	}
	method darDeComer(){}
	
}
