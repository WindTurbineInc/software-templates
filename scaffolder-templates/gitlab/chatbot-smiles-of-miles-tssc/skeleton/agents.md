# Agent Instructions for Smiles of Miles

This document provides comprehensive instructions for AI assistants working on the Kubernetes Agent project. It covers development workflows, testing procedures, deployment strategies, and coding standards.  Do not create redundant .md files to document what you've done. As this is just an experimental project, do not take backwards compatibility in consideration since it will increase complexity unnecessarily.

## Project Overview

The Smiles of Miles Chatbot is a Quarkus-based AI agent that uses LangChain4j's declarative agentic framework to provide car rental bookings and customer supports.

**Key Technologies:**
- Quarkus 3.x with LangChain4j
- Declarative agent orchestration (`@Agent`, `@LoopAgent`, `@SequenceAgent`)
- RAG and Pgvector

## Architecture Principles

When working on this project, always follow these principles:

1. **Declarative Over Programmatic**: Use annotations (`@Agent`, `@LoopAgent`, `@SequenceAgent`) instead of programmatic API
2. **Responsibility-Based Design**: Each agent has a single, clear responsibility
3. **Native Quarkus Integration**: Leverage Quarkus CDI and LangChain4j features
4. **Simple and Clean**: Avoid unnecessary complexity
5. **Type Safety**: Use records for data contracts between agents

## Prerequisites

- Java 17+
- Maven 3.8+
- kubectl configured
- OpenAI compatible API Key

## Development Workflow

### 1. Local Development Setup

```bash

# Run in dev mode (hot reload enabled)
mvn quarkus:dev 


```

**Available Profiles:**
- `dev` - Development mode with debug logging
- `prod` - Production mode


### 2. Making Code Changes

#### Agent Development

When creating or modifying agents:

```java
@Agent
@RegisterAiService
public interface MyAgent {
    
    @SystemMessage("""
        You are a specialized agent responsible for [specific task].
        
        Guidelines:
        - [Guideline 1]
        - [Guideline 2]
        """)
    String execute(String input);
}
```

**Key Points:**
- Use `@Agent` for simple agents
- Use `@LoopAgent` for retry logic with exit conditions
- Use `@SequenceAgent` for orchestrating multiple agents
- Always provide clear system messages
- Return structured data (records) when possible

#### Tool Development

When adding Kubernetes tools:

**Tool Guidelines:**
- Use `@Tool` annotation with clear descriptions
- Use `@P` for parameter documentation
- Return string results (LLM-friendly)
- Handle errors gracefully with try-catch
- Log tool invocations for debugging

### 3. Testing Changes

#### Unit Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=AnalysisAgentTest

# Run with coverage
mvn verify
```

### 4. Building and Packaging

```bash
# Build JAR
mvn clean package

# Build with Quarkus
mvn quarkus:image-build 

# Build and push
mvn quarkus:image-push -Dquarkus.container-image.build=true
```

## Code Style and Standards

### Java Code Style

```java
// Use records for data transfer objects
public record AnalysisResult(
    boolean promote,
    int confidence,
    String analysis,
    String rootCause,
    String remediation,
    String prLink
) {}

// Use declarative agents
@Agent
public interface AnalysisAgent {
    
    @SystemMessage("""
        You are an agent that is able to analyze results from Kubernetes logs and metrics
        """)
    @UserMessage("""
        Analyze the diagnostic data and determine if the canary should be promoted.
        
        Return a JSON object with:
        - promote: boolean
        - confidence: 0-100
        - analysis: detailed analysis
        - rootCause: identified root cause
        - remediation: suggested fix
        """)
    AnalysisResult analyze(String diagnosticData);
}

// Use dependency injection
@ApplicationScoped
public class MyService {
    
    @Inject
    KubernetesWorkflow workflow;
    
    public AnalysisResult analyze(String message) {
        return workflow.execute(UUID.randomUUID().toString(), message);
    }
}
```

### System Message Guidelines

When writing user and system messages for agents:

1. **Be Specific**: Clearly define the agent's role and responsibilities
2. **Provide Structure**: Specify expected output format (JSON, text, etc.)
3. **Set Constraints**: Define what the agent should and shouldn't do
4. **Give Examples**: Include examples when helpful
5. **Use Markdown**: Format for readability

Example:
```java
@SystemMessage("""
    You are a Kubernetes diagnostic agent responsible for gathering cluster information.
    
    Your role:
    - Use available tools to gather pod status, logs, events, and metrics
    - Focus on the specified namespace and pod
    - Collect comprehensive diagnostic data
    - Do NOT analyze or make decisions - only gather data
    
    Available tools:
    - debugPod: Get pod status and conditions
    - getLogs: Retrieve container logs
    - getEvents: Fetch cluster events
    - getMetrics: Check resource usage
    - inspectResources: View related resources
    
    Return all gathered information as a structured report.
    """)
```

### Error Handling

```java
// Use try-catch with proper logging
@Tool("Get pod logs")
public String getLogs(
    String namespace,
    String podName
) {
    try {
        return kubernetesClient
            .pods()
            .inNamespace(namespace)
            .withName(podName)
            .getLog();
    } catch (Exception e) {
        logger.error("Failed to get logs for pod {}/{}", namespace, podName, e);
        return "Error retrieving logs: " + e.getMessage();
    }
}
```

### Logging Standards

```java
// Use appropriate log levels
logger.debug("Starting analysis for pod {}/{}", namespace, podName);
logger.info("Analysis completed: promote={}, confidence={}", result.promote(), result.confidence());
logger.warn("Low confidence score: {}", result.confidence());
logger.error("Analysis failed", exception);

// Include context in log messages
logger.info("Tool invocation: {} with params: {}", toolName, params);
```

## Debugging and Troubleshooting

### View Agent Logs

## Performance Considerations

### Memory Management

```yaml
# Recommended resource limits
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "2Gi"
    cpu: "1000m"
```

### Rate Limiting

The agent includes built-in rate limiting for API calls:

```java
// Configured in application.properties
quarkus.langchain4j.openai.timeout=60s
quarkus.langchain4j.openai.max-retries=3
```

### Tool Call Optimization

```java
// Use ToolCallLimiter to prevent excessive tool calls
@ApplicationScoped
public class ToolCallLimiter {
    private static final int MAX_TOOL_CALLS = 20;
    
    public void checkLimit(int currentCalls) {
        if (currentCalls >= MAX_TOOL_CALLS) {
            throw new IllegalStateException("Tool call limit exceeded");
        }
    }
}
```

## Documentation Standards

When adding new features or modifying existing code:

1. **Update ARCHITECTURE.md**: Document architectural changes
2. **Update README.md**: Update user-facing documentation
3. **Add Javadoc**: Document public APIs and complex logic
4. **Update this file**: Add new workflows or procedures
5. **Add Examples**: Include code examples for new features

## Checklist for New Features

- [ ] Code is as simple, clean and concise as possible
- [ ] Code follows declarative agent pattern from Quarkus LangChain4j (https://github.com/quarkiverse/quarkus-langchain4j)
- [ ] System and user messages are clear and specific
- [ ] Error handling is implemented
- [ ] Logging is appropriate
- [ ] Unit tests are added
- [ ] Integration tests pass
- [ ] Documentation is updated
- [ ] ARCHITECTURE.md reflects changes
- [ ] README.md is updated if needed
- [ ] Code is formatted (mvn fmt:format)
- [ ] No compiler warnings
- [ ] Unit tests are fast

## Resources

- [Quarkus Documentation](https://quarkus.io/guides/)
- [LangChain4j Documentation](https://docs.langchain4j.dev/)
- [Quarkus LangChain4j Extension Documentation](https://docs.quarkiverse.io/quarkus-langchain4j/dev/)
- [Quarkus LangChain4j Source Code](https://github.com/quarkiverse/quarkus-langchain4j)

## Support and Contribution

For questions or issues:
- Check existing GitHub issues
- Review ARCHITECTURE.md for design decisions
- Consult README.md for usage examples
- Ask in project discussions

When contributing:
- Follow the code style guidelines
- Add tests for new features
- Update documentation
- Keep commits focused, short and well-described
- Reference issues in commit messages