#!/bin/bash

# Hoppscotch Management Script

show_help() {
    echo "Hoppscotch Management Commands:"
    echo "  ./manage.sh start    - Start Hoppscotch services"
    echo "  ./manage.sh stop     - Stop Hoppscotch services"
    echo "  ./manage.sh restart  - Restart Hoppscotch services"
    echo "  ./manage.sh logs     - View application logs"
    echo "  ./manage.sh status   - Check service status"
    echo "  ./manage.sh update   - Update and rebuild containers"
    echo "  ./manage.sh backup   - Backup database"
}

case "$1" in
    start)
        echo "🚀 Starting Hoppscotch..."
        docker compose --profile default up -d
        ;;
    stop)
        echo "🛑 Stopping Hoppscotch..."
        docker compose --profile default down
        ;;
    restart)
        echo "🔄 Restarting Hoppscotch..."
        docker compose --profile default restart
        ;;
    logs)
        echo "📋 Showing logs (Press Ctrl+C to exit)..."
        docker compose logs -f
        ;;
    status)
        echo "📊 Service Status:"
        docker compose ps
        echo ""
        echo "💾 Disk Usage:"
        docker system df
        ;;
    update)
        echo "🔄 Updating Hoppscotch..."
        docker compose --profile default down
        docker compose --profile default pull
        docker compose --profile default build --no-cache
        docker compose --profile default up -d
        ;;
    backup)
        echo "💾 Creating database backup..."
        BACKUP_FILE="hoppscotch_backup_$(date +%Y%m%d_%H%M%S).sql"
        docker compose exec hoppscotch-db pg_dump -U postgres hoppscotch > "$BACKUP_FILE"
        echo "✅ Backup saved to: $BACKUP_FILE"
        ;;
    *)
        show_help
        ;;
esac
