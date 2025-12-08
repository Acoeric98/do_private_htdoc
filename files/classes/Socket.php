<?php
class Socket {
    public static function Connection() {
        $host = SOCKET_HOST;
        $port = SOCKET_PORT;
        $timeout = SOCKET_TIMEOUT;

        $socket = @fsockopen("tcp://" . $host . "", $port, $errno, $errstr, $timeout);

        if ($socket === false) {
            error_log('Socket: sikertelen csatlakozás ' . $host . ':' . $port . ' (' . $errno . ' - ' . $errstr . ')');
            return false;
        }

        stream_set_timeout($socket, $timeout);
        return $socket;
    }

    public static function Get($Action, $Parameters) {
        $socket = Socket::Connection();

        if ($socket) {
            $json = json_encode(array('Action' => $Action, 'Parameters' => $Parameters));
            $result = fwrite($socket, $json);

            if ($result === false) {
                error_log('Socket: írási hiba a(z) ' . SOCKET_HOST . ':' . SOCKET_PORT . ' végponton');
                fclose($socket);
                return $Parameters['Return'];
            }

            fflush($socket);
            $response = fread($socket, 1024);
            fclose($socket);
            return $response === "True" ? true : ($response === "False" ? false : $response);
        } else return $Parameters['Return'];
    }

    public static function Send($Action, $Parameters) {
        $socket = Socket::Connection();

        if ($socket) {
            $json = json_encode(array('Action' => $Action, 'Parameters' => $Parameters));
            $result = fwrite($socket, $json);

            if ($result === false) {
                error_log('Socket: írási hiba a(z) ' . SOCKET_HOST . ':' . SOCKET_PORT . ' végponton');
            }

            fflush($socket);
            fclose($socket);
        }
    }
}
?>
