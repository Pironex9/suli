#!bin/bash

echo "Hello, World!"

clear
szam=12         # nincs szóköz és $szam
echo $szam      # ide már kell $szam


clear
a=5
b=7
let c=$a+$b     # így számol
echo $c

d=$(($a+$b))    # így is számol
echo $d

e=$[$a+$b]      # így is számol (de elavult szintaxis)
echo $e

let f=$a/$b     
echo $f

n=10
n=$((n+1))      # növeljük az értéket
echo $n
((n=n+1))       # növeljük az értéket
echo $n
((n+=1))        # növeljük az értéket
echo $n
((n++))         # növeljük az értéket
echo $n


clear
a=5
b=7
kerulet=$(( 2 * (a+b) ))        
echo $kerulet
terulet=$((a * b))
echo $terulet


clear
echo a Kor terulete
R=2
PI=3.14
KT=`echo "$R*$R*$PI" | bc -l` 
echo a Kor terulete=$KT


clear
read -p "Kérem az első számot: " a
read -p "Kérem a második számot: " b
echo "Az első szám: $a"
echo "A második szám: $b"
c=$((a + b))
echo "A $a és $b szám összege: $c"
d=$((a - b))
echo "A $a és $b szám különbsége: $d"
e=$((a * b))
echo "A $a és $b szám szorzata: $e"
e=$((a / b))                                    # egész számokkal osztás
echo "A $a és $b szám hányadosa: $e"            
e=$((a % b))                                    # maradék 
echo "A $a és $b szám maradéka: $e"               
f=$(echo "$a / $b" | bc -l)                     # lebegőpontos osztás
echo "A $a és $b szám hányadosa: $f"



if [ "$a" == "$b" ]
then
    echo "megegyeznek"
else
    echo "nem egyeznek meg"
fi

Alternatíva:

if [ "$a" == "$b" ]; then echo "megegyeznek"; else echo "nem egyeznek meg"; fi



if [ "$a" -gt "$b" ]; then                          # régebbi
    echo "$a nagyobb mint $b"
else
    echo "$a kisebb vagy egyenlő mint $b"
fi

Alternatíva: (( )) szintaxis

if (( a > b )); then                                # modernebb
    echo "$a nagyobb mint $b"
else
    echo "$a kisebb vagy egyenlő mint $b"
fi


if (($a == $b));then                                # elif
    echo "megegyeznek";
elif (($a > $b));then
    echo "$a nagyobb mint $b"
else
    echo "$a kisebb mint $b"
fi


read -p "Kérem a számot: " a                        # paros / paratlan

if (( a % 2 == 0 )); then
    echo "A szám páros."
else
    echo "A szám páratlan."
fi


#---------
# Halmazok
#---------


for i in a b c d e f; do                        # for
    echo $i
done

for i in {1..100}; do
    echo $i
done

for i in {23..100..5}; do
    echo $i
done

a=0                                             # while
while (( a < 10 )); do
    echo $a
    ((a++))
done

for i in {1..100}; do                           # break
    if (( i == 10 )); then break; fi
    echo $i
done

clear
het=(hetfo kedd szerda csutortok pentek szombat vasarnap)

for i in "${het[@]}"; do
    echo "$i"
    echo
done

#----------
# Tobb cucc
#----------



clear
read -p "Kerem a bejegyzest: " file
if [ -e $file ]; then                           # letezik?
	echo Az allomany letezik.
else 
	echo Az allomany nem letezik.
fi
echo Ez allomany-e?
if [ -f $file ]; then                           # allomany-e
	echo $file egy allomany
else
	echo $file nem allomany
fi
echo Konyvtar-e?
if [ -d $file ]; then                           # mappa-e
	echo $file egy mappa
else
	echo $file nem mappa
fi


clear
echo csillagok
for sor in {1..10}; do
	for oszlop in {1..10}; do
	echo -n "* "
	done
echo
done

clear
for i in *; do                                       # fileok listazasa
    echo "$i"
done


clear                                                 # 1. verzio
a=jelszo
b=exit
read -p "Adja meg a jelszot!: " c
while [ $c != $a ]; do
	echo Helytelen jelszo!
	echo "Kilepeshez 'exit'"
	read -p "Adja meg a jelszot!: " c
	if [ $c == $b ]; then
		break
	fi
done
if [ $c == $a ]; then
	echo Helyes jelszo!
fi

clear                                                  # 2. verzio
a="jelszo"
b="exit"
while true; do
    read -p "Adja meg a jelszót!: " c

    if [ "$c" == "$a" ]; then
        echo "Helyes jelszó!"
        break
    elif [ "$c" == "$b" ]; then
        echo "Kilépés..."
        break
    else
        echo "Helytelen jelszó!"
    fi
done


clear
read -p "Kerem az masolando allomanyt: " file
read -p "Kerem a cel mappat: " mappa
if [ -f "$file" ] && [ -d "$mappa" ]; then
    cp "$file" "$mappa"
    echo "Sikeres másolás."
    ls "$file" "$mappa"
else
    echo "Hiba: a fájl vagy a mappa nem létezik!"
fi


clear
allomany='elso.sh'
if [ -f $allomany ]; then
	echo "$allomany" letezik es torlom
	rm "$allomany"
else
echo "$allomany" nem letezik
fi

clear
het="napok.txt"                                                 # kiiras filebol
i=1
while read -r sor; do
  echo "$i: $sor"
  ((i++))
done < "$het"

clear
het='napok.txt'
while read sor; do
	if [ "$sor" == "szerda" ]; then
		echo Szerda mar letezik
	fi
done < "$het" 

clear
echo -n "Mit keresek: "
read mit
if grep $mit napok.txt > /dev/null; then
	echo Benne van a $mit szoveg
else
	echo Nincs benne a $mit szoveg
fi


clear
echo -n "Kit keresek?: "
read ki

if grep -q "^$ki:" /etc/passwd; then
    echo "$ki már létezik"
else
    echo "$ki nem létezik. Létrehozom."
    sudo adduser "$ki"


clear
szam=0
atlag=0
osszeg=0
db=0
until [ "$szam" == "q" ]; do
	read -p "Kerek egy szamot 0 es 100 kozott. (kilepes q betu): " szam
	if (($szam < 0 )) || (( $szam > 100 )); then
		echo "Nem megfelelo a szam!"
		read szam
	else
		((db++))
		osszeg=$((osszeg+szam))
	fi
done
atlag=$((osszeg/db-1))
echo a szamok osszege: $osszeg
echo a szamok darabszama: $((db-1))
echo a szamok atlaga: $atlag


clear                                       # 10 veletlen szam
for i in {1..10}; do
	echo -n $i. $((RANDOM))
	echo
done

clear                                       # 10 veletlen szam 10 es 100 kozott
for i in {1..10}; do
    echo "$i. $((RANDOM % 90 + 10))"
done


clear                                                       # 1-100 ig tippeles
    szam=$((RANDOM % 100 + 1))
while true; do
	read -p "Tippelj egyet 1-100-ig (q kilep)" tipp
	if (( tipp == szam)); then
		echo "eltalatad a $szam szamra gondoltam"
        break
	elif
		[[ "$tipp" == "q" ]]; then
			echo "Kileptel"
			break
	elif
		(( tipp < szam )); then
			echo "tul kicsi"
	else 
		echo "tul nagy"
	fi
done


#----------------
# File kezelés
#----------------


clear                     
datum=`date`              # változóba tesszük a 'date' parancs kimenetét (backtick szintaxis)
echo A mai datum: $datum  # kiírjuk a változó tartalmát

clear
echo ki van bejelentkezve: `w | wc -l`			# mennyi felhasználó van bejelentkezve


# inditas $ ./elso.sh alma korte
clear
echo az allomany neve: $0  			# az allomany neve: pelda.sh
echo az elso parameter: $1  		# az elso parameter: Alma
echo a masodik parameter: $2		# a masodik parameter: Korte
echo a parameterek szama: $#		# a parameterek szama: 2
echo "Paraméterek: $@"				# Paraméterek: Alma Korte
echo "Paraméterek (egybe): $*"		# Paraméterek (egybe): Alma Korte

# $* → az összes paramétert egy stringként adja vissza, szóközzel elválasztva.
# $@ → az összes paramétert külön elemenként, idézőjelek között is megtartja a szóközöket.
# Példa:
# $* → Alma Korte Eper Pite
# $@ → "Alma" "Korte" "Eper Pite"

clear
if [ $# -lt 2 ]; then							
	echo "Hiba, legalabb 2 parameter kell!"
	exit 1
fi
echo "Elso parameter $1"
echo "Masodik parameter $2"

clear
echo "Az állomány neve: $0"
echo "A paraméterek száma: $#"
echo "Az elemek listája: $*"
# Paraméterek kiírása külön-külön
echo "Paraméterek külön-külön:"
for i in "$@"; do
    echo $i
done
elso=$1
masodik=$2
harmadik=$3
negyedik=$4
echo "Első paraméter: $elso"
echo "Második paraméter: $masodik"
echo "Harmadik paraméter: $harmadik"
echo "Negyedik paraméter: $negyedik"

clear
read -p "Adja meg a mappa nevet: " mappa
read -p "Adja meg a file nevet: " file
if [ -d $mappa ] && [ -f $file ]; then
	echo a $file file letezik a $mappa mappaban
else
	echo nem letezik
fi

clear
read -p "Adja meg a fájl nevét, amit másolni szeretne: " file
read -p "Adja meg a mappa nevét, ahova másoljam: " mappa
if [ ! -d "$mappa" ]; then
    echo "Nem létezik a $mappa mappa"
elif [ ! -f "$file" ]; then
    echo "Nem létezik a $file fájl"
elif [ -e "$mappa/$file" ]; then
    echo "A $file fájl már létezik a $mappa mappában"
    exit 1
else
    cp "$file" "$mappa"
    echo "Átmásoltam a $file fájlt a $mappa mappába"
fi

clear
echo Rendszerinformaciok
echo 
uname -a
if [ -f /etc/os-release ]; then
	echo "Distribution: "
	grep -E '^NAME=|^VERSION=' /etc/os-release
fi
lscpu | grep -E '^Architecture:|^Model name:|^CPU\(s\):|^Vendor ID:'		
echo
free -h
echo
df -h
echo
hostname -I
echo
ip link show | grep -B1 "state UP" | grep -E '^[0-9]'			# -B1 az előző sort is kiírja


clear
echo Felhasznalok listaja
awk -F':' '{print $1}' /etc/passwd | sort	# -F':' – ezzel állítjuk be az oszlopelválasztót. Az /etc/passwd fájl mezői :-vel vannak elválasztva.
echo "Csoportok listaja"
awk -F':' '{print $1}' /etc/group | sort

#-------------------------
# Felhasználók létrehozása
#-------------------------
clear
echo "Felhasználók létrehozása"
# csak root futtathatja
if [ "$EUID" -ne 0 ]; then
    echo "Hiba: csak root felhasználó futtathatja." >&2
    exit 1
fi

read -p "Add meg a felhasználónevet: " username
# trim? (nem feltétlen szükséges) — ellenőrzés:
if [[ -z "$username" ]]; then
    echo "A felhasználónév nem lehet üres." >&2
    exit 1
fi

# létezik-e már a felhasználó?
if getent passwd "$username" >/dev/null; then
    echo "Hiba: a felhasználó '$username' már létezik." >&2
    exit 1
fi

# jelszó csendben (nem jelenik meg a képernyőn)
read -s -p "Add meg a jelszót: " password
echo
read -s -p "Add meg még egyszer a jelszót: " password2
echo

if [[ -z "$password" ]]; then
    echo "A jelszó nem lehet üres." >&2
    exit 1
fi

if [[ "$password" != "$password2" ]]; then
    echo "A jelszavak nem egyeznek." >&2
    exit 1
fi

# létrehozás
if useradd -m -s /bin/bash -- "$username"; then
    # jelszó beállítása biztonságos módon
    printf "%s:%s\n" "$username" "$password" | chpasswd
    # sudo csoport hozzáadása
    usermod -aG sudo -- "$username"
    echo "Sikeresen létrehozva: $username"
    exit 0
else
    echo "Hiba a felhasználó létrehozásakor." >&2
    exit 2
fi
#----------------
# Vége
#----------------

