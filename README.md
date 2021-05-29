# oneshifter.vhdl
//generic ve kayma hizi degistirilebilen bir one shifter (kaydirici) programidir.
program 100 Mhz ana calisma frekansina sahiptir.
sel fonksiyonu ile kontrol edilir sel=0 ise 100MHz sel=1 ise 50Mhz sel=2 ise 25Mhz sel=3 ise 10Mhz frekanslarinda calisir.
led degiskeninin bir uzunlugu generic olarak degistirilebilir
program kaymaya soldan saga dogru baslamaktadir
rst ile sifirlanabilir
test benchlerden test soncları gozlemlenebilir.
