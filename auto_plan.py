import string
import random
def id_generator(size=17, chars=string.ascii_uppercase + string.digits):
       return ''.join(random.choice(chars) for _ in range(size))

Marka = ['Opel', 'Alfa Romeo', 'BMW', 'Audi', 'Toyota', 'Smart', 'Kia', 'Peugeot', 'Range Rover', 'Mercedes', 'Fiat', 'Ford', 'Honda', 'Hyundai', 'Jeep', 'Jaguar', 'Mazda', 'MINI', 'Renault', 'Subaru', 'Volvo', 'Suzuki']
Model = ['Astra', 'i30', 'focus', 'A4', 'A8', 'Vitara', 'Ibiza', 'Leon', 'i20', 'i10', '208', '308', 'M4', 'Seria 3', 'Corolla', 'Velar', 'Discovery', 'Punto', 'Laguna']
Godina_proizvodnje = [2000, 2001, 2003,2004, 2005, 2006,2007, 2008, 2009,2012,2014]
Potrosnja = [5.6, 2.4, 6.5, 9.7, 10.5, 5.5, 5.3, 6.1, 4.7, 4.3, 7.3, 8.8]
Pocetni_broj_kilometara = [12301, 123123, 12345, 54001, 1231, 9564, 87453, 120564, 304321, 231311, 20012, 34758, 234102]

f = open("auto_plan.sql", "a")
for x in range(0,100000):
	f.write("INSERT INTO auto_plan(broj_sasije, marka, model, godina_proizvodnje, potrosnja, pocetni_broj_kilometara)\nVALUES ('{}','{}','{}', {}, {}, {});\n".format(id_generator(), 
		random.choice(Marka), random.choice(Model), random.choice(Godina_proizvodnje), random.choice(Potrosnja), random.choice(Pocetni_broj_kilometara)))

f.close()