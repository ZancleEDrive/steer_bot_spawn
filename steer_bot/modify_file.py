import sys

def modify_file(file_path):
    try:
        with open(file_path, 'r') as file:
            file_data = file.read()
        
        new_data = file_data.replace("math.sin(ix / 10.0) * ix / 5.0", "math.sin(ix / 8.33) * ix / 4.0")
        
        with open(file_path, 'w') as file:
            file.write(new_data)

        print(f"Modifica di {file_path} completata.")
    
    except Exception as e:
        print(f"Errore: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python modify_file.py <percorso-del-file>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    modify_file(file_path)
