// file: "Repl.java", Time-stamp: <2007-04-04 14:41:26 feeley>

// Copyright (c) 2004-2007 by Marc Feeley, All Rights Reserved.

// This program can be run from the command line or as an applet.
// From the command line:
//
//   % javac Repl.java
//   % gsi -:dar web-repl &
//   % java Repl

import java.io.*;
import java.net.*;

import java.awt.*;
import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.text.*;

class shelldoc extends DefaultStyledDocument {

    private Position output_pos = null;
    private SimpleAttributeSet plain;
    private SimpleAttributeSet bold;
    private SimpleAttributeSet attr;

    public void set_output_offs(int offs) {
        if (offs <= 0)
            output_pos = null;
        else {
            try {
                output_pos = createPosition(offs-1);
            }
            catch (BadLocationException e) {
                output_pos = null;
            }
        }
    }

    public int get_output_offs() {
        if (output_pos == null)
            return 0;
        else
            return output_pos.getOffset()+1;
    }

    public void set_bold_attr(boolean b) {
        if (b)
            attr = bold;
        else
            attr = plain;
    }

    public void insertString(int offset,
                             String str,
                             AttributeSet a)
        throws BadLocationException {
        super.insertString(offset, str, attr);
    }

    public shelldoc() {
        plain = new SimpleAttributeSet();
        bold = new SimpleAttributeSet();
        StyleConstants.setBold(bold, true);
        set_bold_attr(true);
    }
}

class shellpane extends JTextPane implements KeyListener {

    private final static String charset = "ISO-8859-1";//"UTF-16BE"
    private final static int charset_size = 1;//2

    public PipedInputStream input;
    public PipedOutputStream input_out;
    public PipedOutputStream output;
    public PipedInputStream output_in;

    public void keyTyped(KeyEvent e) {
    }

    public void keyPressed(KeyEvent e) {
        int kc = e.getKeyCode();
        if (kc == KeyEvent.VK_ENTER) {
            e.consume();
            replaceSelection("\n");
            send_input();
        }
    }

    public void keyReleased(KeyEvent e) {
    }

    public void send_input() {
        shelldoc doc = (shelldoc)getDocument();
        int start = doc.get_output_offs();
        int end = getCaretPosition();
        String str;
        if (end <= start)
            str = "";
        else {
            try {
                str = doc.getText(start, end-start);
            }
            catch (BadLocationException e) {
                str = "";
            }
        }
        doc.set_output_offs(end);
        try {
            input_out.write(str.getBytes(charset));
            input_out.flush();
        }
        catch (IOException e) {
            System.out.println("send_input caught IOException");
        }
    }

    public void add_output(String text) {
        shelldoc doc = (shelldoc)getDocument();
        try {
            int len = text.length();
            int offs = doc.get_output_offs();
            int s = getSelectionStart();
            int e = getSelectionEnd();
            doc.set_bold_attr(false);
            doc.insertString(offs, text, null);
            doc.set_bold_attr(true);
            doc.set_output_offs(offs + len);
            if (e >= offs) {
                if (s < offs)
                    setCaretPosition(s);
                else
                    setCaretPosition(s + len);
                moveCaretPosition(e + len);
            }
        }
        catch (BadLocationException e) {
            System.out.println("add_output caught BadLocationException");
        }
    }

    public shellpane() {
        shelldoc doc = new shelldoc();
        setStyledDocument(doc);
        setPreferredSize(new Dimension(600, 400));
        setFont(new Font("Courier", Font.PLAIN, 12));
        addKeyListener(this);

        try {
            input_out = new PipedOutputStream();
            input = new PipedInputStream(input_out);
            output_in = new PipedInputStream();
            output = new PipedOutputStream(output_in);

            Thread t = new Thread() {
                    public void run() {
                        byte byte_buf[] = new byte[1024];
                        int n = 0;

                        try {
                            for (;;) {
                                int x = output_in.read(byte_buf, n, byte_buf.length-n);
                                if (x <= 0)
                                    break;
                                n += x;
                                int len = (n/charset_size)*charset_size;
                                add_output(new String(byte_buf, 0, len, charset));
                                if (len == n)
                                    n = 0;
                                else {
                                    byte_buf[0] = byte_buf[len];
                                    n = 1;
                                }
                            }
                        }
                        catch (IOException e) {
                            System.out.println("shellpane thread caught IOException");
                        }
                    }
                };
            t.start();
        }
        catch (IOException e) {
            System.out.println("shellpane caught IOException");
        };
    }
}

class shellclient {

    private Socket sock;
    private DataOutputStream out;
    private DataInputStream in;
    private shellpane shell;

    public shellpane get_shellpane() {
        return shell;
    }

    public shellclient(String hostname, int port) {
        shell = new shellpane();
        try {
            sock = new Socket(hostname, port);
            out = new DataOutputStream(sock.getOutputStream());
            in = new DataInputStream(sock.getInputStream());

            Thread t1 = new Thread() {
                    public void run() {
                        OutputStream out = shell.output;
                        byte byte_buf[] = new byte[1024];
                        try {
                            for (;;) {
                                int len = in.read(byte_buf, 0, byte_buf.length);
                                if (len <= 0)
                                    break;
                                out.write(byte_buf, 0, len);
                                out.flush();
                            }
                        }
                        catch (IOException e) {
                            System.out.println("shellclient thread 1 caught IOException");
                        }
                    }
                };
            t1.start();

            Thread t2 = new Thread() {
                    public void run() {
                        InputStream in = shell.input;
                        byte byte_buf[] = new byte[1024];
                        try {
                            for (;;) {
                                int len = in.read(byte_buf, 0, byte_buf.length);
                                out.write(byte_buf, 0, len);
                                out.flush();
                            }
                        }
                        catch (IOException e) {
                            System.out.println("shellclient thread 2 caught IOException");
                        }
                    }
                };
            t2.start();
        } catch (UnknownHostException e) {
            System.out.println("shellclient caught UnknownHostException");
        } catch (IOException e) {
            System.out.println("shellclient caught IOException");
        }
    }
}

public class Repl extends JApplet {

    private final static String default_hostname = "localhost";
    private final static int default_port = 7000;

    private Container content;
    private shellpane shell;

    private void start_shell(String hostname, int port) {
        shell = new shellclient(hostname, port).get_shellpane();
        content.add(new JScrollPane(shell));
    }

    public void init() {
        String hostname = getParameter("hostname");
        if (hostname == null)
            hostname = default_hostname;

        int port = default_port;
        String port_str = getParameter("port");
        if (port_str != null)
            port = Integer.parseInt(port_str);

        start_shell(hostname, port);
    }

    public Repl() {
        content = getContentPane();
    }

    public Repl(JFrame frame) {
        content = frame.getContentPane();
    }

    private static String main_args[] = null;

    private static void invoked_later() {

        JFrame.setDefaultLookAndFeelDecorated(true);
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        Repl x = new Repl(frame);

        String hostname = default_hostname;
        if (main_args.length >= 1)
            hostname = main_args[0];

        int port = default_port;
        if (main_args.length >= 2)
            port = Integer.parseInt(main_args[1]);

        x.start_shell(hostname, port);

        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) {
        main_args = args;
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                invoked_later();
            }
        });
    }
}
