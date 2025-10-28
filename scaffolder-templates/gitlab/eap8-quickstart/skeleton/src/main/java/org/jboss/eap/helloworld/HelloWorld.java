/*
 * JBoss, Home of Professional Open Source
 * Copyright 2015, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.eap.helloworld;
import java.util.HashMap;
import java.util.Map;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

/**
 * A simple REST service which is able to say hello to someone using HelloService Please take a look at the web.xml where JAX-RS
 * is enabled And notice the @PathParam which expects the URL to contain /json/David or /xml/Mary
 *
 * @author bsutter@redhat.com
 */

@ApplicationScoped
@Path("/")
public class HelloWorld {

    @GET
    @Path("/javadetails")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> geJavaDetails() {
        Map<String, String> dets = new HashMap<>();
        dets.put("Vendor", System.getProperty("java.vendor"));
        dets.put("Vendor Link", System.getProperty("java.vendor.url"));
        dets.put("Version", System.getProperty("java.version"));
        return dets;
    }

    @GET
    @Path("/serverconfig/{name}")
    @Produces(MediaType.TEXT_PLAIN)
    public String getServerConfig(@PathParam("name") String name) {
        return System.getProperty(name);
    }

    @GET
    @Path("/serverconfig")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> getAll() {
        return (Map)System.getProperties();
    }

    @GET
    @Path("/openshiftconfig")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> getOpenshift() {
        Map<String, String> dets = new HashMap<>();
        dets.put("Project name", System.getenv("OPENSHIFT_BUILD_NAMESPACE"));
        dets.put("Build", System.getenv("OPENSHIFT_BUILD_NAME"));
        dets.put("Pod name", System.getenv("HOSTNAME"));
        dets.put("JBoss Home", System.getenv("JBOSS_HOME"));
        return dets;
    }
}
