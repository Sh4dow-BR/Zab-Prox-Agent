#!/bin/bash

###############################################
# ///                                     \\\ #
#    Você pode mudar as variáveis aqui :D     #
#        Criado pelo Sh4dow-BR                #
#                                             #
###############################################

##### Variaveis para os arquivos: /etc/zabbix/zabbix_proxy.conf e /etc/zabbix/zabbix_agent2.conf

# Agent configs
agent_logfile_size=0 #default=0
agent_passive_server_ip=127.0.0.1 #default=127.0.0.1
agent_active_server_ip=127.0.0.1 #default=127.0.0.1

# Proxy configs
proxy_mode=1 #default=1 & passivo=0
proxy_server_ip=127.0.0.1 #default=127.0.0.1
log_file_size=1 #default=1
enable_remote_commands=0 #default=0 & enable=1
log_remote_commands=0 #default=0 & enable=1
DBname_local=/tmp/proxy.db #default=zabbix_proxy
proxy_local_buffer=0 #default=0
proxy_offline_buffer=0 #default=0
config_frequency=3600 #default=3600
housekeeping_frequency=1 #default=1
timeout=4 #default=4

###############################################

# As cores que podem ser utilizados:
red=$(tput setaf 1 && tput bold)
green=$(tput setaf 2 && tput bold)
yellow=$(tput setaf 3 && tput bold)
blue=$(tput setaf 4 && tput bold)
cyan=$(tput setaf 5 && tput bold)
white=$(tput setaf 6 && tput bold)
bold=$(tput bold)
reset=$(tput sgr0)

###############################################

# Output de toda a instalação para um arquivo
#LOG_LOCATION=(pwd)
#exec >> $LOG_LOCATION/mylogfile.log 2>&1
#exec > ${LOG_LOCATION}/mylogfile3.log 2>&1
#exec >> $LOG_LOCATION/mylogfile4.log 2>&1
#exec > ${LOG_LOCATION}/mylogfile5.log 2>&1
#exec >> $LOG_LOCATION/mylogfile6.log 2>&1
#exec > ${LOG_LOCATION}/mylogfile7.log 2>&1

#### Função global para ser chamado quando o case é verdadeiro para assim configurar os configs padroes.

hostnamectl_grep () {
hostnamectl | grep hostname
hostnamectl | grep Icon
hostnamectl | grep Chassis
hostnamectl | grep Virtualization
hostnamectl | grep Operating
hostnamectl | grep Kernel
hostnamectl | grep Architecture
}

change_hostname () {
echo ""
echo -n "Novo hostname: "
read novo_hostname
hostnamectl set-hostname "$novo_hostname"
echo "------------------------------------"
hostnamectl_grep
echo ""
}

change_hostname_case () {
# Mudar o hostname
echo ""
echo "${bold}Quer mudar o hostname da maquina? ${reset}"
echo "${red} 1 - Sim ${reset}"
echo "${red} 2 - Não ${reset}"

read hostname_change;

case $hostname_change in
        1)
	change_hostname
	;;
	2)
	echo ""
	echo "${blue}Continuando a instalação${reset}"
	echo ""
	;;
	*)
	;;
esac
}

hostnamectl_version () {
hostnamectl | grep Operating | awk '{print $3,$4,$5,$6}'
}

hostnamectl_version=$(hostnamectl | grep Operating | awk '{print $3,$4,$5,$6}')
selinux_mode=$(sestatus | grep | awk '{print $3}')

limpa_cache_e_update () {
echo "${red}-------------- Limpando o cache e atualizando os pacotes --------------${reset}"; sleep 1
apt-get clean
# Atualizar os pacotes recente do repository debian **EXTREMAMENTE IMPORTE**
apt update
# Opcional
# apt upgrade
# apt install -f
}

instalacao_debian_10 () {
# Chamar a função para fazer limpeza e update dos pacotes
limpa_cache_e_update
echo ""
echo "${red}-------------- Baixando Zabbix do Repo oficial --------------${reset}"; sleep 1
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-proxy-sqlite3_6.0.3-1+debian10_amd64.deb
echo "${red}-------------- Unpacking o proxy --------------${reset}"; sleep 1
dpkg -i zabbix-proxy-sqlite3_6.0.3-1+debian10_amd64.deb
echo "${red}-------------- Instalando as dependencias necessarias --------------${reset}"; sleep 1
apt --fix-broken install -y
echo ""
echo "${red}-------------- Zabbix Proxy Version --------------${reset}"
zabbix_proxy -V
echo ""
echo "${red}-------------- Baixando o Zabbix Agent 2 --------------${reset}"; sleep 1
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.3-1+debian10_amd64.deb
echo "${red}-------------- Unpacking o Agent 2 --------------${reset}"; sleep 1
dpkg -i zabbix-agent2_6.0.3-1+debian10_amd64.deb
echo ""
echo "${red}-------------- Zabbix Agent Version --------------${reset}"
zabbix_agent2 -V
echo ""
echo "${green}-------------- Instalação completa em $SECONDS segundos --------------${reset}"
# Chamar a função para executar a mudança de configuração
setup_configuration
su
}

instalacao_debian_11 () {
# Chamar a função para fazer limpeza e update dos pacotes
limpa_cache_e_update
echo ""
echo "${red}-------------- Baixando Zabbix do Repo oficial --------------${reset}"; sleep 1
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-proxy-sqlite3_6.0.3-1+debian11_amd64.deb
echo "${red}-------------- Unpacking o proxy --------------${reset}"; sleep 1
dpkg -i zabbix-proxy-sqlite3_6.0.3-1+debian11_amd64.deb; echo ""
echo "${red}-------------- Zabbix Proxy Version --------------${reset}"
zabbix_proxy -V
echo ""
echo "${red}-------------- Baixando o Zabbix Agent 2 --------------${reset}"; sleep 1
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.3-1+debian11_amd64.deb
echo "${red}-------------- Unpacking o Agent 2 --------------${reset}"; sleep 1
dpkg -i zabbix-agent2_6.0.3-1+debian11_amd64.deb
echo "${red}-------------- Instalando as dependencias necessarias --------------${reset}"; sleep 1
apt --fix-broken install -y
echo ""
echo "${red}-------------- Zabbix Agent Version --------------${reset}"
zabbix_agent2 -V
echo "${green}-------------- Instalação completa em $SECONDS segundos --------------${reset}"
# Chamar a função para executar a mudança de configuração
setup_configuration
su
}

instalacao_centos_7 () {
echo -e "${red}-------------- Verificando se tem autalizções pendentes e atualizando os pacotes --------------${reset}"; sleep 1
yum check-update | yum update
yum install epel-release
yum install yum-utils
echo "${red}-------------- Baixando Zabbix do Repo oficial --------------${reset}"; sleep 1
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-proxy-sqlite3-6.0.3-1.el7.x86_64.rpm
echo "${red}--------------  unpacking o proxy --------------${reset}"; sleep 1
dnf clean all | dnf install zabbix-proxy-sqlite3
echo "${red}-------------- Zabbix Proxy Version --------------${reset}"
zabbix_proxy -V
echo "${red}-------------- Baixando o Zabbix Agent 2 --------------${reset}"; sleep 1
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-agent2-6.0.3-1.el7.x86_64.rpm
echo "${red}-------------- Limpando o cache e unpacking o Agent 2 --------------${reset}"; sleep 1
dnf clean all | dnf install zabbix-agent2
echo "${red}-------------- Zabbix Agent Version --------------${reset}"
zabbix_agent2 -V
echo "${green}-------------- Instalação completa em $SECONDS segundos --------------${reset}"
setup_configuration
}

instalacao_centos_8 () {
## Site para trocar o appstream do mirror.centos.org para vault.centos.org pois não participa mais do stream original e o EOL foi em 2021.
## https://www.gnulinuxbrasil.com.br/2022/04/12/centos-8-com-erro-centos-8-appstream-error-failed-to-download-metadata-for-repo-appstream-cannot-prepare-internal-mirrorlist-no-urls-in-mirrorlist/
echo -e "${red}----------- Verificando se tem atualizações pendentes e atualizando os pacotes -----------${reset}"; sleep 1
# yum check-update | yum update
# yum install epel-release
# yum install yum-utils
echo -e "${red}----------- Verificando se o SELINUX esta ativo e trocando se necessario -----------${reset}"; sleep 1

if [ "$selinux_mode" = 'enforcing' ]; then
	echo 'Selinux está enforcing e será trocado para disabled'
	# Trocando o antigo enforcing para disabled
	sed -i "s@SELINUX=enforcing@SELINUX=disabled@g" /etc/selinux/config
	# Setando temporariamente para permissive pois para o disabled entrar em efeito precisa de reiniciar a maquina
	setenforce 0
	echo ""
	echo 'SELINUX: Modo temporario de "permissive" após a mudança'
	sestatus | Current
	echo 'Continuando a instalação'
else
	echo 'O SELINUX mode não está "enforcing" e continuando a instalação'
fi

echo "${red}-------------- Baixando Zabbix do Repo oficial --------------${reset}"; sleep 1
rpm -ivh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-proxy-sqlite3-6.0.3-1.el8.x86_64.rpm
echo "${red}-------------- Limpando o cache e unpacking o proxy --------------${reset}"; sleep 1
dnf clean all
dnf install zabbix-proxy-sqlite3 -y
echo "${red}-------------- Zabbix Proxy Version --------------${reset}"
zabbix_proxy -V
echo "${red}-------------- Baixando o Zabbix Agent 2 --------------${reset}"; sleep 1
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-agent2-6.0.3-1.el8.x86_64.rpm
echo "${red}-------------- Limpando o cache e unpacking o Agent 2 --------------${reset}"; sleep 1
dnf install zabbix-agent2
echo "${red}-------------- Zabbix Agent Version --------------${reset}"
zabbix_agent2 -V
echo "${green}-------------- Instalação completa em $SECONDS segundos --------------${reset}"; sleep 1
setup_configuration
}

# Utilize '' para troca de strings normais: 's@STRING_ORIGINAL@STRING_REPLACEMENT@g' <arquivo que vai ser editado>
# Utilize "" para troca de strings com variveis: "s@STRING_ORIGINAL@STRING_REPLACEMENT=${VARIAVEL}@g" <arquivo que vai ser editado>

# Como utilizar o SED: https://linuxize.com/post/how-to-use-sed-to-find-and-replace-string-in-files/

setup_configuration () {
echo ""
echo "${red}-------------- Mudando as configurações do Zabbix Agent 2 --------------${reset}"; sleep 2

# Troca do agent_logfile_size
  sed -i "s@LogFileSize=0@LogFileSize=${agent_logfile_size}@g" /etc/zabbix/zabbix_agent2.conf
# Troca do Passive Server IP
  sed -i "s@Server=127.0.0.1@Server=${agent_passive_server_ip}@g" /etc/zabbix/zabbix_agent2.conf
# Troca do Active Server IP
  sed -i "s@ServerActive=127.0.0.1@ServerActive=${agent_active_server_ip}@g" /etc/zabbix/zabbix_agent2.conf
# Troca de Hostname
  sed -i 's@Hostname=Zabbix server@Hostname='`cat /etc/hostname`'@g' /etc/zabbix/zabbix_agent2.conf

echo ""
echo "${red}-------------- Mudando as configurações do Zabbix Proxy Conf --------------${reset}"; sleep 2
# Troca do Proxy Mode
  sed -i "s@# ProxyMode=0@ProxyMode=${proxy_mode}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Server IP
  sed -i "s@Server=127.0.0.1@Server=${proxy_server_ip}@g" /etc/zabbix/zabbix_proxy.conf
# Troca de Hostname
  sed -i 's@Hostname=Zabbix proxy@Hostname='`cat /etc/hostname`'@g' /etc/zabbix/zabbix_proxy.conf
# Troca do Log File Size
  sed -i "s@LogFileSize=0@LogFileSize=${log_file_size}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Enable Remote Commands
  sed -i "s@# EnableRemoteCommands=0@EnableRemoteCommands=${enable_remote_commands}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Log Remote Commands
  sed -i "s@# LogRemoteCommands=0@LogRemoteCommands=${log_remote_commands}@g" /etc/zabbix/zabbix_proxy.conf
# Troca de DBname
  sed -i "s@DBName=zabbix_proxy@DBName=${DBname_local}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Proxy Local Buffer
  sed -i "s@# ProxyLocalBuffer=0@ProxyLocalBuffer=${proxy_local_buffer}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Proxy Offline Buffer
  sed -i "s@# ProxyOfflineBuffer=1@ProxyOfflineBuffer=${proxy_offline_buffer}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Config Frequency
  sed -i "s@# ConfigFrequency=3600@ConfigFrequency=${config_frequency}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Housekeeping Frequency
  sed -i "s@# HousekeepingFrequency=1@HousekeepingFrequency=${housekeeping_frequency}@g" /etc/zabbix/zabbix_proxy.conf
# Troca do Timeout
  sed -i "s@Timeout=4@Timeout=${timeout}@g" /etc/zabbix/zabbix_proxy.conf

echo ""
echo "${red}-------------- Gerando as chaves de PSK do Zabbix Proxy --------------${reset}"; sleep 2
# Gerando Chave PSK
  openssl rand -hex 32 > /etc/zabbix/zabbix_proxy.psk
# Troca de TLSConnect
  sed -i 's@# TLSConnect=unencrypted@TLSConnect=psk@g' /etc/zabbix/zabbix_proxy.conf
# Troca de TLSAccept
  sed -i 's@# TLSAccept=unencrypted@TLSAccept=psk@g' /etc/zabbix/zabbix_proxy.conf
# Troca de TLSPSKIdentity
  sed -i 's@# TLSPSKIdentity=@TLSPSKIdentity=PSK_'`cat /etc/hostname`'@g' /etc/zabbix/zabbix_proxy.conf
# Troca de TLSPSKFile
  sed -i 's@# TLSPSKFile=@TLSPSKFile=/etc/zabbix/zabbix_proxy.psk@g' /etc/zabbix/zabbix_proxy.conf

echo ""
echo "${red}-------------- Enabling e Resetando o Serviço Proxy e Agent 2 --------------${reset}"; sleep 2
# Restart Serviço Proxy
chown -R zabbix. /etc/zabbix
systemctl enable zabbix-proxy.service && systemctl enable zabbix-agent2.service
systemctl start zabbix-proxy.service && systemctl start zabbix-agent2.service
systemctl restart zabbix-proxy.service && systemctl restart zabbix-agent2.service

echo ""
echo "${red}-------------- Status do Agent2 --------------${reset}"; sleep 2
systemctl status zabbix-agent2.service --no-pager

echo ""
echo "${red}-------------- Status do Proxy --------------${reset}"; sleep 2
systemctl status zabbix-proxy.service --no-pager

echo ""
echo "${red}-------------- Chaves de PSK --------------${reset}"; sleep 2
# Identidade PSK e chave PSK
echo "Identidade PSK e chave PSK precisa ser inserido no caminho no Zabbix Frontend: Administration -> Proxies -> Encryption"
echo ""
echo "Identidade PSK: PSK_`cat /etc/hostname`"
echo "Chave PSK: `cat /etc/zabbix/zabbix_proxy.psk`"
echo ""
}

#*#*#*#*#*#*#*# Incio dos comandos #*#*#*#*#*#*#*#

clear

echo ""
echo ""

echo "${blue}  _____   _    ____        ____  ____   _____  __       _    ____ _____ _   _ _____ ${reset}"
echo "${blue} |__  /  / \  | __ )      |  _ \|  _ \ / _ \ \/ /      / \  / ___| ____| \ | |_   _|${reset}"
echo "${blue}   / /  / _ \ |  _ \ _____| |_) | |_) | | | \  /_____ / _ \| |  _|  _| |  \| | | |  ${reset}"
echo "${blue}  / /_ / ___ \| |_) |_____|  __/|  _ <| |_| /  \_____/ ___ \ |_| | |___| |\  | | |  ${reset}"
echo "${blue} /____/_/   \_\____/      |_|   |_| \_\\____/_/\_\   /_/   \_\____|_____|_| \_| |_| ${reset}"
echo "${blue} Author: https://github.com/Sh4d0w-BR  ${reset}"

echo ""
echo "${green}-------------- Verificando informações do host --------------${reset}"; sleep 2
echo ""
# Chamar a função de hostnamectl
hostnamectl_grep

if [ "$1" = 'change' ]; then
	# Chama a função para trocar o hostname porque o parâmetro "change" foi inserido com o script
	change_hostname
elif [ "$1" = 'run' ]; then
	# Executando a instalação sem trocar o hostname
	echo ""
	echo 'Executando a instalação'
else
	# Chamar a função para seguir com o case normal porque não inseriu um parâmetro
	change_hostname_case
fi

echo "CTL VERSION FUNCTION"
echo ${hostnamectl_version}

if [ "$hostnamectl_version" = 'Debian GNU/Linux 9 (stretch)' ]; then
	echo "SUCCESS"
	instalacao_debian_9
elif [ "$hostnamectl_version" = 'Debian GNU/Linux 10 (buster)' ]; then
    echo "SUCCESS"
    instalacao_debian_10
elif [ "$hostnamectl_version" = 'Debian GNU/Linux 11 (bullseye)' ]; then
    echo "SUCCESS"
    instalacao_debian_11		
elif [ "$hostnamectl_version" = 'CentOS Linux 7 ' ]; then
    echo "SUCCESS"
	instalacao_centos_7
elif [ "$hostnamectl_version" = 'CentOS Linux 8 ' ]; then
    echo "SUCCESS"
	instalacao_centos_8
elif [ "$hostnamectl_version" = 'CentOS Linux 9 ' ]; then
    echo "SUCCESS"
	instalacao_centos_9
else
	echo "FAIL: Não tem a instalação para essa maquina"
fi
