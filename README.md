# Claude Code Setup for FoodTech

Установка плагина, скиллов и агентов для Claude Code в один клик.

## Установка

```bash
git clone https://github.com/v1tbrah/claude-setup.git && cd claude-setup && ./install.sh
```

## Обновление

```bash
cd claude-setup && git pull && ./install.sh
```

## Что устанавливается

### Плагин

- **superpowers** — brainstorming, TDD, планирование, дебаггинг, code review и другие навыки

### Скиллы

| Скилл | Описание | Вызов |
|-------|----------|-------|
| knowledgebase-prd | Создание PRD из задачи | `/knowledgebase-prd` |
| knowledgebase-decision | Документирование архитектурных решений (ADR) | `/knowledgebase-decision` |
| team-lead | Оркестрация агентов для параллельной работы | `/team-lead` |

### Агенты

| Агент | Описание |
|-------|----------|
| judge | Ревью кода воркеров: проверка спеки, качества, тестов |
| worker | Имплементация задач с self-review loop и TDD |

## Использование

Для реализации задачи рекомендуется явно вызвать `/team-lead` и передать ему задачу:

```
> /team-lead FOOD-1234 Добавить эндпоинт для получения списка категорий
```

Team-lead сам создаст PRD (если нет), спланирует работу, раздаст задачи воркерам и проведёт ревью через judge.

## Проверка

После установки откройте Claude Code и проверьте:

```
> /knowledgebase-prd
```

Если скилл загрузился — всё работает.

## Настройка MCP-серверов

MCP-серверы (Atlassian, GitLab, Slack, Grafana) настраиваются отдельно — см. [инструкцию в Confluence](https://confluence.uzum.com/pages/viewpage.action?pageId=514658828).
