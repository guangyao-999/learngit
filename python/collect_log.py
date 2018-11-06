# -*- coding: utf-8 -*-

from ftplib import FTP
import tarfile
import net, shell_command, mkdir_p
PATH = "/opt/ftpshare/share/"
PORT = 9093
USER = "share"
PASSWD = "share"

class CollectManager():
    __metaclass__ = Singleton

    def __init__(self):
        self.host_ip = None
        self.ftp = None 
        mkdir_p(PATH)

    def ftpconnect(self, host, username, password):
        # ftp.set_debuglevel(2)
        self.ftp = FTP()
        self.ftp.connect(host, 21)
        self.ftp.login(username, password)
        return self.ftp

    def uploadfile(self, remotepath, localpath):
        bufsize = 1024
        fp = open(localpath, 'rb')
        self.ftp.storbinary('STOR ' + remotepath, fp, bufsize)
        self.ftp.set_debuglevel(0)
        self.ftp.close()

    def collect_log(self, ftp_server):

        file_name = "%s.tar.gz" % (self.host_ip)
        local_path = "%s%s.tar.gz" % (PATH, self.host_ip)
        cmd = "tar zcvf %s%s.tar.gz -C /var/ --exclude=log/lastlog log  &> /dev/null" % (PATH, self.host_ip)
        ret = shell_command(cmd)

        if ret != SUCCESS:
            logger.warn("collect log fail!")

        self.ftpconnect(ftp_server, USER, PASSWD)
        self.uploadfile(file_name, local_path)

    def _system_log_collect(self, ftp_server, ip):
        var = (ftp_server,)
        for i in range(10):
            ret = remote.call_remote("collect_log", ip, PORT, None, *var)
            if ret == SUCCESS:
                break
        
    def system_log_collect(self, ftp_server, server_list):
        """一键采集系统日志"""
        threads = []

        for ip in server_list:
            if not net.addr_check(ip):
                logger.warn("%s can't arrive" % ip)
                continue
            t = threading.Thread(target=self._system_log_collect, name='collect log', args=(ftp_server, ip))
            t.start()
            threads.append(t)

        for t in threads:
            t.join()
            
if __name__ == "__main__":
    manager = CollectManager()
    manager.collect_log("192.168.1.1")