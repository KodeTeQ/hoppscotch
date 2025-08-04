#!/bin/bash

# Hoppscotch Production Deployment Script
echo "🚀 Deploying Hoppscotch AIO..."

# Check if environment variables are properly set
if grep -q "YOUR_SERVER_IP" .env; then
    echo "❌ Error: Please replace YOUR_SERVER_IP in .env with your actual server IP address"
    echo "Edit .env file and replace all instances of YOUR_SERVER_IP with your server's IP"
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker compose --profile default down

# Pull latest images and rebuild
echo "🔨 Building containers..."
docker compose --profile default build --no-cache

# Start the application
echo "▶️ Starting Hoppscotch AIO..."
docker compose --profile default up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if containers are running
echo "🔍 Checking container status..."
docker compose ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📱 Access URLs:"
echo "   Main App: http://$(hostname -I | awk '{print $1}'):3000"
echo "   Admin Panel: http://$(hostname -I | awk '{print $1}'):3001"
echo "   Backend API: http://$(hostname -I | awk '{print $1}'):3002"
echo ""
echo "🔧 Useful commands:"
echo "   View logs: docker compose logs -f"
echo "   Stop: docker compose --profile default down"
echo "   Restart: docker compose --profile default restart"
