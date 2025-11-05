echo "Запускаем OpenBMC Mock Server..."
echo "Доступ по: http://localhost:4430"

cd /var/jenkins_home/workspace/openbmc-ci/mock-openbmc
python3 server.py > qemu.log 2>&1 &
SERVER_PID=$!

echo $SERVER_PID > /tmp/qemu.pid

echo "⏳ Ожидание готовности OpenBMC..."
sleep 2

if curl -s http://localhost:4430/redfish/v1 > /dev/null; then
    echo "OpenBMC Mock готов!"
    exit 0
else
    echo "Mock не ответил"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi