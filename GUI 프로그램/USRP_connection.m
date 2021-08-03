function [output,address,platform]=USRP_connection()
connectedRadios = findsdru;
if strncmp(connectedRadios(1).Status, 'Success', 7)
    address = connectedRadios(1).IPAddress;
    platform = connectedRadios(1).Platform;
    output=connectedRadios(1).Status;
else
    address=[];
    platform=[];
    output=connectedRadios(1).Status;
end

