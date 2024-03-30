package room;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

import cartago.Artifact;
import cartago.OPERATION;

/**
 * A CArtAgO artifact that provides an operation for sending messages to agents 
 * with KQML performatives using the dweet.io API
 */
public class DweetArtifact extends Artifact {

    public void init() {
        
    }
    
    @OPERATION
    public void sendDweet(String receiver, String action, String content) {
        try{
            String payload = "{\"receiver\":\"" + receiver + "\",\"action\":\"" + action + "\",\"content\":\"" + content + "\"}";
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest
                .newBuilder()
                .uri(URI.create("https://dweet.io/dweet/for/" + receiver ))
                .header("Content-Type", "application/json")
                .POST(BodyPublishers.ofString(payload))
                .build();
            HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
            System.out.println("Status: " + response.statusCode());
            System.out.println("Body: " + response.body());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
